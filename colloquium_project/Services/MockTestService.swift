//
//  MockTestService.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import Foundation

protocol TestServiceProtocol {
    func fetchTest(completion: @escaping (Result<Test, Error>) -> Void)
}

final class MockTestService: TestServiceProtocol {
    func fetchTest(completion: @escaping (Result<Test, Error>) -> Void) {
        // Mock questions
        let q1 = Question(id: "q3",
                          title: "Как сделать enum десериализуемым?",
                          type: .singleChoice,
                          options: [
                            AnswerOption(id: "a", text: "Использовать UserDefaults"),
                            AnswerOption(id: "b", text: "Через протокол Codable"),
                            AnswerOption(id: "c", text: "Хранить в @Published свойстве"),
                            AnswerOption(id: "d", text: "Реализовать Hashable и Equatable")
                          ],
                          minSymbols: 0)
        let q2 = Question(id: "q4",
                          title: "Схема какой архитектуры приведена на картинке?",
                          type: .singleChoice,
                          options: [
                            AnswerOption(id: "a", text: "MVVM"),
                            AnswerOption(id: "b", text: "MVC"),
                            AnswerOption(id: "c", text: "SVIP"),
                            AnswerOption(id: "d", text: "VIPER")
                          ],
                          minSymbols: 0)
        let test = Test(id: "t1", title: "iOS Mock Test", durationSeconds: 3600, questions: [q1, q2])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            completion(.success(test))
        }
    }
}
