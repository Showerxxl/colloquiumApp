//
//  AssistantAuthPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

final class AssistantAuthPresenter: AssistantAuthPresentationLogic {
    
    weak var view: AssistantAuthViewController?
    
    func routingToAssistantStart() {
        guard let navigationController = view?.navigationController else {
            print("❌ navigationController is nil!")
            return
        }
        let vc = AssistantStartBuilder.build()
        navigationController.pushViewController(vc, animated: true)
    }
}
