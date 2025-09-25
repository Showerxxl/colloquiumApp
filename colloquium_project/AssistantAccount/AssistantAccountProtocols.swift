//
//  AssistantAccountProtocols.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import Foundation

protocol AssistantAccountPresentationLogic {
    func showUsername(name: String, email: String)
    func routingToAuth()
}

protocol AssistantAccountInteractionLogic {
    func getUserData()
    func logOut()
}
