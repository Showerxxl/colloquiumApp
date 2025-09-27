import Foundation
import FirebaseFirestore

protocol StudentHistoryService {
    func fetchAttempts(forEmail email: String, completion: @escaping (Result<[AttemptDTO], Error>) -> Void)
}

final class FirebaseStudentHistoryService: StudentHistoryService {
    private let db = Firestore.firestore()
    
    func fetchAttempts(forEmail email: String, completion: @escaping (Result<[AttemptDTO], Error>) -> Void) {
        db.collection("testAttempts")
            .whereField("email", isEqualTo: email)
            .order(by: "createdAt", descending: true)
            .getDocuments { snap, err in
                if let err = err { completion(.failure(err)); return }
                guard let docs = snap?.documents else { completion(.success([])); return }
                
                let items: [AttemptDTO] = docs.compactMap { doc -> AttemptDTO? in
                    let data = doc.data()
                    guard
                        let testId = data["testId"] as? String,
                        let code   = data["code"]   as? String,
                        let email  = data["email"]  as? String
                    else { return nil }
                    
                    let createdAt: Date = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()

                    let rawAnswers = (data["answers"] as? [[String: Any]]) ?? []
                    let answers: [AnswerDTO] = rawAnswers.compactMap { dict -> AnswerDTO? in
                        guard let qid = dict["questionId"] as? String else { return nil }
                        let ans = (dict["answer"] as? String) ?? ""
                        return AnswerDTO(questionId: qid, answer: ans)
                    }
                    
                    return AttemptDTO(
                        id: doc.documentID,
                        testId: testId,
                        code: code,
                        email: email,
                        createdAt: createdAt,
                        answers: answers
                    )
                }
                completion(.success(items))
            }
    }
}
