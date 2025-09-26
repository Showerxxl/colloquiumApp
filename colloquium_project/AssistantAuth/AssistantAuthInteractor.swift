//
//  AssistantAuthInteractor.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import FirebaseAuth
import FirebaseFirestore

final class AssistantAuthInteractor: AssistantAuthInteractionLogic {
    
    private let presenter: AssistantAuthPresentationLogic
    
    init(presenter: AssistantAuthPresentationLogic) {
        self.presenter = presenter
    }
    
    func SendUserData(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {
            authResult, error in
            if let error = error {
                print("Assistant sign in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                return
            }
            
            let uid = user.uid
            let db = Firestore.firestore()
            
            db.collection("users").document(uid).getDocument {
                document, error in
                if let data = document?.data(), data["type"] as? String == "assistant" {
                    if let username = data["username"] as? String {
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(email, forKey: "email")
                    }
                    self.presenter.routingToAssistantStart()
                    print("Assistant signed in")
                } else {
                    print("Not an assistant")
                }
            }
        }
    }
}
