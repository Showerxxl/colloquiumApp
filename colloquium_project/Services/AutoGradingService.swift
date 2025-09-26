//
//  AutoGradingService.swift
//  colloquium_project
//
//  Created by AI Assistant
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol AutoGradingServiceProtocol {
    func submitForAutoGrading(submissionId: String, completion: @escaping (Error?) -> Void)
    func listenToAutoGradingResults(submissionId: String, completion: @escaping (GradingResult?) -> Void)
    func stopListeningToGradingResults()
}

struct GradingResult {
    let autoScore: Int
    let autoFeedback: String
    let questionScores: [String: QuestionScore]
    let gradedAt: Date?
    let gradingMethod: String?
    let autoGradeError: String?
    
    // New convenience initializer for previews and manual construction
    init(autoScore: Int,
         autoFeedback: String,
         questionScores: [String: QuestionScore],
         gradedAt: Date? = nil,
         gradingMethod: String? = nil,
         autoGradeError: String? = nil) {
        self.autoScore = autoScore
        self.autoFeedback = autoFeedback
        self.questionScores = questionScores
        self.gradedAt = gradedAt
        self.gradingMethod = gradingMethod
        self.autoGradeError = autoGradeError
    }
    
    init(from document: DocumentSnapshot) {
        let data = document.data() ?? [:]
        
        self.autoScore = data["autoScore"] as? Int ?? 0
        self.autoFeedback = data["autoFeedback"] as? String ?? ""
        self.gradedAt = (data["gradedAt"] as? Timestamp)?.dateValue()
        self.gradingMethod = data["gradingMethod"] as? String
        self.autoGradeError = data["autoGradeError"] as? String
        
        var questionScores: [String: QuestionScore] = [:]
        if let scores = data["questionScores"] as? [String: [String: Any]] {
            for (questionId, scoreData) in scores {
                let score = scoreData["score"] as? Int ?? 0
                let comment = scoreData["comment"] as? String ?? ""
                questionScores[questionId] = QuestionScore(score: score, comment: comment)
            }
        }
        self.questionScores = questionScores
    }
}

struct QuestionScore {
    let score: Int
    let comment: String
}

final class AutoGradingService: AutoGradingServiceProtocol {
    private let db = Firestore.firestore()
    private var gradingListener: ListenerRegistration?
    
    deinit {
        stopListeningToGradingResults()
    }
    
    // Отправка ответов на автоматическую проверку
    func submitForAutoGrading(submissionId: String, completion: @escaping (Error?) -> Void) {
        db.collection("submissions").document(submissionId).updateData([
            "status": "submitted",
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    // Прослушивание результатов автоматической проверки
    func listenToAutoGradingResults(submissionId: String, completion: @escaping (GradingResult?) -> Void) {
        stopListeningToGradingResults() // Останавливаем предыдущий listener
        
        gradingListener = db.collection("submissions").document(submissionId)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Ошибка прослушивания результатов проверки: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                guard let snapshot = snapshot, snapshot.exists else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }
                
                let data = snapshot.data() ?? [:]
                let autoGraded = data["autoGraded"] as? Bool ?? false
                
                if autoGraded {
                    let result = GradingResult(from: snapshot)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                } else if let _ = data["autoGradeError"] as? String {
                    // Есть ошибка автоматической проверки
                    let result = GradingResult(from: snapshot)
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
            }
    }
    
    // Остановка прослушивания
    func stopListeningToGradingResults() {
        gradingListener?.remove()
        gradingListener = nil
    }
    
    // Получение результатов проверки без прослушивания
    func getGradingResult(submissionId: String, completion: @escaping (Result<GradingResult?, Error>) -> Void) {
        db.collection("submissions").document(submissionId).getDocument { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                DispatchQueue.main.async {
                    completion(.success(nil))
                }
                return
            }
            
            let data = snapshot.data() ?? [:]
            let autoGraded = data["autoGraded"] as? Bool ?? false
            
            if autoGraded || data["autoGradeError"] != nil {
                let result = GradingResult(from: snapshot)
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(nil))
                }
            }
        }
    }
    
    // Создание нового submission
    func createSubmission(userId: String, colloquiumId: String, answers: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let submissionId = UUID().uuidString
        
        let data: [String: Any] = [
            "userId": userId,
            "colloquiumId": colloquiumId,
            "status": "draft",
            "answers": answers,
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("submissions").document(submissionId).setData(data) { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(submissionId))
                }
            }
        }
    }
    
    // Обновление ответов в черновике
    func updateSubmissionAnswers(submissionId: String, answers: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("submissions").document(submissionId).updateData([
            "answers": answers,
            "updatedAt": FieldValue.serverTimestamp()
        ]) { error in
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
    
    // Получение всех submission пользователя для конкретного коллоквиума
    func getUserSubmissions(userId: String, colloquiumId: String, completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        db.collection("submissions")
            .whereField("userId", isEqualTo: userId)
            .whereField("colloquiumId", isEqualTo: colloquiumId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.success(snapshot?.documents ?? []))
                    }
                }
            }
    }
}
