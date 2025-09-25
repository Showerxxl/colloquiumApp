//
//  AssistantAccountInteractor.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import Foundation
import FirebaseAuth

final class AssistantAccountInteractor: AssistantAccountInteractionLogic {
    
    private let presenter: AssistantAccountPresentationLogic
    
    init(presenter: AssistantAccountPresentationLogic) {
        self.presenter = presenter
    }
    
    func getUserData() {
        if let username = UserDefaults.standard.string(forKey: "username"), let email = UserDefaults.standard.string(forKey: "email") {
            presenter.showUsername(name: username, email: email)
        } else {
            // TODO: вот тут по идее что-то явно не так пошло и надо выкинуться
            print("can't get username from userDefaults")
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "email")
            
            DispatchQueue.main.async {
                self.presenter.routingToAuth()
                print("User successfully logged out")
            }
        } catch let error as NSError {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
