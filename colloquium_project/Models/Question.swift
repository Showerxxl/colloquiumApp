//
//  Question.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

struct Question {
    let id: String
    let title: String
    let type: QuestionType
    let options: [AnswerOption]
    let minSymbols: Int
}
