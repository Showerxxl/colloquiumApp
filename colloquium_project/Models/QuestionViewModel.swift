//
//  QuestionViewModel.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

struct QuestionViewModel {
    let id: String
    let title: String
    let type: QuestionType
    let options: [AnswerOption]
    let minSymbols: Int
    let index: Int
    let total: Int
    let existingText: String?
    let selectedOptionId: String?
    let isBackEnabled: Bool
    let isNextEnabled: Bool
}
