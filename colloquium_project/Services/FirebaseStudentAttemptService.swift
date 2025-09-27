import FirebaseFirestore

protocol StudentAttemptService {
    /// Ищем одну попытку по email и code и возвращаем пары (questionTitle, answer)
    func fetchAttempt(email: String, code: String, completion: @escaping (Result<[(title: String, answer: String)], Error>) -> Void)
}

final class FirebaseStudentAttemptService: StudentAttemptService {
    private let db = Firestore.firestore()

    func fetchAttempt(email: String, code: String, completion: @escaping (Result<[(title: String, answer: String)], Error>) -> Void) {
        db.collection("testAttempts")
            .whereField("email", isEqualTo: email)
            .whereField("code",  isEqualTo: code)
            .limit(to: 1)
            .getDocuments { [weak self] snap, err in
                if let err = err { completion(.failure(err)); return }
                guard
                    let doc = snap?.documents.first
                else { completion(.success([])); return }

                let data = doc.data()

                // answers — массив map'ов вида { "questionId": "q39", "answer": "..." }
                let rawAnswers = (data["answers"] as? [[String: Any]]) ?? []
                let answers: [AnswerDTO] = rawAnswers.compactMap {
                    guard let qid = $0["questionId"] as? String else { return nil }
                    let ans = ($0["answer"] as? String) ?? ""
                    return AnswerDTO(questionId: qid, answer: ans)
                }

                let ids = answers.map { $0.questionId }
                self?.fetchQuestionTitles(forIDs: ids) { result in
                    switch result {
                    case .failure(let e):
                        completion(.failure(e))
                    case .success(let titlesById):
                        let rows: [(String, String)] = answers.map { a in
                            let title = titlesById[a.questionId] ?? "Вопрос \(a.questionId)"
                            return (title, a.answer)
                        }
                        completion(.success(rows))
                    }
                }
            }
    }

    /// Тянем тексты вопросов из коллекции questions по их полю id (string).
    /// Firestore 'in' допускает максимум 10 значений — разобьём по чанкам.
    private func fetchQuestionTitles(forIDs ids: [String], completion: @escaping (Result<[String: String], Error>) -> Void) {
        guard !ids.isEmpty else { completion(.success([:])); return }

        let chunks: [[String]] = stride(from: 0, to: ids.count, by: 10).map {
            Array(ids[$0..<min($0+10, ids.count)])
        }

        var result: [String: String] = [:]
        var need = chunks.count
        var failed: Error?

        for chunk in chunks {
            db.collection("questions")
                .whereField("id", in: chunk)
                .getDocuments { snap, err in
                    if let err = err { failed = err }
                    if let docs = snap?.documents {
                        for d in docs {
                            let data = d.data()
                            if let qid = data["id"] as? String,
                               let title = data["title"] as? String {
                                result[qid] = title
                            }
                        }
                    }
                    need -= 1
                    if need == 0 {
                        if let failed { completion(.failure(failed)) }
                        else { completion(.success(result)) }
                    }
                }
        }
    }
}
