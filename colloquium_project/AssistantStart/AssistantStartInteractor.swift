//
//  AssistantStartInteractor.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

final class AssistantStartInteractor: AssistantStartInteractionLogic {
    private let presenter: AssistantStartPresentationLogic
    
    init(presenter: AssistantStartPresentationLogic) {
        self.presenter = presenter
    }
    
    func routingToAssistantAccount() {
        presenter.routingToAssistantAccount()
    }
}
