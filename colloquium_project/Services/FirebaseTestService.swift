import Foundation
import FirebaseFirestore

final class FirebaseTestService: TestServiceProtocol {
    private let db = Firestore.firestore()
    
    private let testId = "firestore-test"
    private let testTitle = "iOS Test"
    private let defaultDuration: Int = 3600
    
    func fetchTest(completion: @escaping (Result<Test, Error>) -> Void) {
        db.collection("questions")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let docs = snapshot?.documents, !docs.isEmpty else {
                    completion(.success(Test(id: self.testId,
                                             title: self.testTitle,
                                             durationSeconds: self.defaultDuration,
                                             questions: [])))
                    return
                }
                
                var questions: [Question] = []
                questions.reserveCapacity(docs.count)
                
                for doc in docs {
                    let data = doc.data()
                    
                    let qId = (data["id"] as? String) ?? doc.documentID
                    guard let title = data["title"] as? String else { continue }
                    
                    if let rawType = data["type"] as? String,
                       let qType = QuestionType(raw: rawType),
                       qType != .open {
                        continue
                    }
                    
                    let minSymbols = (data["minSymbols"] as? Int) ?? 0
                    let optionStrings = data["options"] as? [String] ?? []
                    let options = optionStrings.enumerated().map { idx, text in
                        AnswerOption(id: "opt\(idx)", text: text)
                    }
                    
                    let q = Question(
                        id: qId,
                        title: title,
                        type: .open,
                        options: options,
                        minSymbols: minSymbols
                    )
                    questions.append(q)
                }
                
                // Берём случайные 10 (или меньше, если в базе меньше)
                let picked = Array(questions.shuffled().prefix(40))
                
                let test = Test(
                    id: self.testId,
                    title: self.testTitle,
                    durationSeconds: self.defaultDuration,
                    questions: picked
                )
                completion(.success(test))
            }
    }
    
    private static func smartSort(_ a: Question, _ b: Question) -> Bool {
        func num(_ s: String) -> Int? { Int(s.filter(\.isNumber)) }
        switch (num(a.id), num(b.id)) {
        case let (la?, lb?): return la < lb
        default: return a.title.localizedCaseInsensitiveCompare(b.title) == .orderedAscending
        }
    }
}
