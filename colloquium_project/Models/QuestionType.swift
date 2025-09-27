//
//  QuestionType.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

enum QuestionType {
    case open
    case singleChoice
}

extension QuestionType {
    init?(raw: String) {
        switch raw.lowercased() {
        case "open": self = .open
        case "single", "singlechoice": self = .singleChoice
        default: return nil
        }
    }
}
