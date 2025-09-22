//
//  TestState.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

struct TestState {
    let test: Test
    let currentIndex: Int
    let answersText: [String: String]
    let answersOption: [String: String]
    let remainingSeconds: Int // optional: can be calculated by Interactor if you track timer there
}
