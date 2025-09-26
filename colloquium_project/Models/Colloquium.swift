//
//  Colloquium.swift
//  colloquium_project
//
//  Created by AI Assistant
//

import Foundation
import FirebaseFirestore

struct Colloquium {
    let id: String
    let title: String
    let description: String?
    let startsAt: Date
    let endsAt: Date
    let isActive: Bool
    let createdAt: Date
    let questions: [ColloquiumQuestion]
    
    init(id: String, title: String, description: String? = nil, startsAt: Date, endsAt: Date, isActive: Bool = true, createdAt: Date = Date(), questions: [ColloquiumQuestion] = []) {
        self.id = id
        self.title = title
        self.description = description
        self.startsAt = startsAt
        self.endsAt = endsAt
        self.isActive = isActive
        self.createdAt = createdAt
        self.questions = questions
    }
    
    init?(from document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String
        self.startsAt = (data["startsAt"] as? Timestamp)?.dateValue() ?? Date()
        self.endsAt = (data["endsAt"] as? Timestamp)?.dateValue() ?? Date()
        self.isActive = data["isActive"] as? Bool ?? true
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        self.questions = [] // Вопросы загружаются отдельно
    }
}

struct ColloquiumQuestion {
    let id: String
    let order: Int
    let type: QuestionType
    let text: String
    let options: [AnswerOption]
    let correctOptionIds: [String]?
    let minSymbols: Int
    
    init(id: String, order: Int, type: QuestionType, text: String, options: [AnswerOption] = [], correctOptionIds: [String]? = nil, minSymbols: Int = 0) {
        self.id = id
        self.order = order
        self.type = type
        self.text = text
        self.options = options
        self.correctOptionIds = correctOptionIds
        self.minSymbols = minSymbols
    }
    
    init?(from document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.order = data["order"] as? Int ?? 0
        self.text = data["text"] as? String ?? ""
        self.minSymbols = data["minSymbols"] as? Int ?? 0
        self.correctOptionIds = data["correctOptionIds"] as? [String]
        
        // Парсинг типа вопроса
        let typeString = data["type"] as? String ?? "text"
        switch typeString {
        case "single_choice":
            self.type = .singleChoice
        case "multiple_choice":
            self.type = .multipleChoice
        case "text":
            self.type = .open
        default:
            self.type = .open
        }
        
        // Парсинг вариантов ответов
        var options: [AnswerOption] = []
        if let optionsData = data["options"] as? [[String: Any]] {
            for optionData in optionsData {
                if let id = optionData["id"] as? String,
                   let text = optionData["text"] as? String {
                    options.append(AnswerOption(id: id, text: text))
                }
            }
        }
        self.options = options
    }
}

struct Submission {
    let id: String
    let userId: String
    let colloquiumId: String
    let status: SubmissionStatus
    let answers: [String: Any]
    let createdAt: Date
    let updatedAt: Date
    let autoGraded: Bool?
    let autoScore: Int?
    let autoFeedback: String?
    let gradedAt: Date?
    let questionScores: [String: QuestionScore]?
    let gradingMethod: String?
    let autoGradeError: String?
    
    init(id: String, userId: String, colloquiumId: String, status: SubmissionStatus, answers: [String: Any], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.userId = userId
        self.colloquiumId = colloquiumId
        self.status = status
        self.answers = answers
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.autoGraded = nil
        self.autoScore = nil
        self.autoFeedback = nil
        self.gradedAt = nil
        self.questionScores = nil
        self.gradingMethod = nil
        self.autoGradeError = nil
    }
    
    init?(from document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        
        self.id = document.documentID
        self.userId = data["userId"] as? String ?? ""
        self.colloquiumId = data["colloquiumId"] as? String ?? ""
        self.createdAt = (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
        self.updatedAt = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        self.answers = data["answers"] as? [String: Any] ?? [:]
        self.autoGraded = data["autoGraded"] as? Bool
        self.autoScore = data["autoScore"] as? Int
        self.autoFeedback = data["autoFeedback"] as? String
        self.gradedAt = (data["gradedAt"] as? Timestamp)?.dateValue()
        self.gradingMethod = data["gradingMethod"] as? String
        self.autoGradeError = data["autoGradeError"] as? String
        
        // Парсинг статуса
        let statusString = data["status"] as? String ?? "draft"
        switch statusString {
        case "draft":
            self.status = .draft
        case "submitted":
            self.status = .submitted
        case "graded":
            self.status = .graded
        default:
            self.status = .draft
        }
        
        // Парсинг оценок по вопросам
        var questionScores: [String: QuestionScore] = [:]
        if let scores = data["questionScores"] as? [String: [String: Any]] {
            for (questionId, scoreData) in scores {
                let score = scoreData["score"] as? Int ?? 0
                let comment = scoreData["comment"] as? String ?? ""
                questionScores[questionId] = QuestionScore(score: score, comment: comment)
            }
        }
        self.questionScores = questionScores.isEmpty ? nil : questionScores
    }
}

enum SubmissionStatus: String, CaseIterable {
    case draft = "draft"
    case submitted = "submitted"
    case graded = "graded"
    
    var displayName: String {
        switch self {
        case .draft:
            return "Черновик"
        case .submitted:
            return "Отправлено"
        case .graded:
            return "Проверено"
        }
    }
}
