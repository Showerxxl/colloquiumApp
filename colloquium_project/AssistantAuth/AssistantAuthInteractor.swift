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
                    self.routingToAssistantLoggedIn()
                    print("Assistant signed in")
                } else {
                    print("Not an assistant")
                }
            }
        }
    }
    
    private func routingToAssistantLoggedIn() {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                let view = AssistantBuilder.build()
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = view
                }, completion: nil)
            }
        }
    }
}
