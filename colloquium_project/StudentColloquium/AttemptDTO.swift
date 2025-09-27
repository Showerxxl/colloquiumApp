import Foundation

struct AttemptDTO {
    let id: String
    let testId: String
    let code: String
    let email: String
    let createdAt: Date
    let answers: [AnswerDTO]
}

struct AnswerDTO {
    let questionId: String
    let answer: String
}

// Question (из questions)
struct QuestionDTO {
    let id: String
    let title: String
}
