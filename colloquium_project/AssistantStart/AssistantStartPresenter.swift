//
//  AssistantStartPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

final class AssistantStartPresenter: AssistantStartPresentationLogic {
    weak var view: AssistantStartViewController?
    
    func routingToAssistantAccount() {
        guard let navigationController = view?.navigationController else {
            print("❌ navigationController is nil!")
            return
        }
        let vc = AssistantAccountBuilder.build()
        navigationController.pushViewController(vc, animated: true)
    }
}
