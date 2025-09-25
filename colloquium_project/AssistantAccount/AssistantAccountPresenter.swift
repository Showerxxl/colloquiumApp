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
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let vc = RootAuthModuleBuilder.build()
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = vc
            }, completion: nil)
        }
    }
}
