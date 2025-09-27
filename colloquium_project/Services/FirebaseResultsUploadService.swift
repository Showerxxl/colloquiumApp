import Foundation
import FirebaseFirestore

protocol ResultsUploadService {
    /// Загружает попытку прохождения теста с ответами.
    func uploadResults(
        testId: String,
        code: String,
        email: String,
        answers: [(questionId: String, answer: String)],
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class FirebaseResultsUploadService: ResultsUploadService {
    private let db = Firestore.firestore()

    func uploadResults(
        testId: String,
        code: String,
        email: String,
        answers: [(questionId: String, answer: String)],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Гарантированно содержим: code, email, и массив с questionId/answer
        let payload: [String: Any] = [
            "testId": testId,
            "code": code,
            "email": email,
            "answers": answers.map { ["questionId": $0.questionId, "answer": $0.answer] },
            "createdAt": FieldValue.serverTimestamp()
        ]

        // Можно сделать document id = testId+code+timestamp, но обычно addDocument ок
        db.collection("testAttempts").addDocument(data: payload) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
