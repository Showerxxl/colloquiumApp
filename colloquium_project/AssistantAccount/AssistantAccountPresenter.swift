//
//  AssistantAccountPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import UIKit

final class AssistantAccountPresenter: AssistantAccountPresentationLogic {
    
    weak var view: AssistantAccountViewController?
    
    func showUsername(name: String, email: String) {
        view?.loadUserData(loadingName: name, loadingEmail: email)
    }
    
    func routingToAuth() {
        let vc = RootAuthModuleBuilder.build()
        view?.navigationController?.setViewControllers([vc], animated: true)
    }
}
