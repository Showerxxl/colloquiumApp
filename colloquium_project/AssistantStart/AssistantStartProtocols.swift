//
//  AssistantStartProtocols.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

protocol AssistantStartPresentationLogic {
    func routingToAssistantAccount()
    func routingToChooseStudents(students: [Student])
    func routingToAssesment()
}

protocol AssistantStartInteractionLogic {
    func routingToAssistantAccount()
    func routingToChooseStudents()
    func routingToAssesment()
}
