import Foundation

struct AttemptDTO {
    let id: String
    let testId: String
    let code: String
    let email: String
    let createdAt: Date
    // answers можно хранить, если понадобится детальный просмотр
    // let answers: [(questionId: String, answer: String)]
}
