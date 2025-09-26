//
//  MockAutoGradingService.swift
//  colloquium_project
//
//  Created by AI Assistant
//

import Foundation
import FirebaseFirestore

// Mock сервис для демонстрации работы автоматической проверки
// В реальном приложении замените на AutoGradingService после настройки Cloud Functions

final class MockAutoGradingService: AutoGradingServiceProtocol {
    private var gradingResults: [String: GradingResult] = [:]
    
    func submitForAutoGrading(submissionId: String, completion: @escaping (Error?) -> Void) {
        // Имитируем задержку обработки
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Создаем mock результат
            let mockResult = self.createMockGradingResult()
            self.gradingResults[submissionId] = mockResult
            completion(nil)
        }
    }
    
    func listenToAutoGradingResults(submissionId: String, completion: @escaping (GradingResult?) -> Void) {
        // Проверяем, есть ли уже результат
        if let result = gradingResults[submissionId] {
            completion(result)
            return
        }
        
        // Имитируем получение результата через некоторое время
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let mockResult = self.createMockGradingResult()
            self.gradingResults[submissionId] = mockResult
            completion(mockResult)
        }
    }
    
    func stopListeningToGradingResults() {
        // В mock версии ничего не делаем
    }
    
    private func createMockGradingResult() -> GradingResult {
        let scores = [7, 8, 9, 6, 8] // Случайные оценки
        let totalScore = scores.randomElement() ?? 7
        
        let feedbacks = [
            "Хорошая работа! Есть небольшие неточности, но в целом ответы правильные.",
            "Отличная работа! Ответы демонстрируют глубокое понимание материала.",
            "Удовлетворительно. Некоторые ответы требуют доработки.",
            "Требуется дополнительная подготовка по данной теме."
        ]
        
        let feedback = feedbacks.randomElement() ?? feedbacks[0]
        
        let questionScores: [String: QuestionScore] = [
            "q1": QuestionScore(score: scores.randomElement() ?? 7, comment: "Правильный ответ"),
            "q2": QuestionScore(score: scores.randomElement() ?? 6, comment: "Частично правильно"),
            "q3": QuestionScore(score: scores.randomElement() ?? 8, comment: "Хорошо объяснено")
        ]
        
        return GradingResult(
            autoScore: totalScore,
            autoFeedback: feedback,
            questionScores: questionScores,
            gradedAt: Date(),
            gradingMethod: "huggingface",
            autoGradeError: nil
        )
    }
}

// Расширение для совместимости с протоколом
extension MockAutoGradingService {
    func getGradingResult(submissionId: String, completion: @escaping (Result<GradingResult?, Error>) -> Void) {
        if let result = gradingResults[submissionId] {
            completion(.success(result))
        } else {
            completion(.success(nil))
        }
    }
    
    func createSubmission(userId: String, colloquiumId: String, answers: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        let submissionId = UUID().uuidString
        completion(.success(submissionId))
    }
    
    func updateSubmissionAnswers(submissionId: String, answers: [String: Any], completion: @escaping (Error?) -> Void) {
        completion(nil)
    }
    
    func getUserSubmissions(userId: String, colloquiumId: String, completion: @escaping (Result<[DocumentSnapshot], Error>) -> Void) {
        completion(.success([]))
    }
}
