import UIKit
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class StudentInteractor: StudentInteractorProtocol {
    
    private let db = Firestore.firestore()
    
    init() {
        print("StudentInteractor initialized with Firebase")
    }
    
    // TODO: сделать регулярку для почты 
    func saveUserData(username: String, email: String) {
        // MARK: тут раскомментить если с акканутом
//        guard !username.isEmpty, !email.isEmpty else {
//            print("Incomplete data for saving")
//            return
//        }
//        
//        let actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.url = URL(string: "https://ios-colloquium.web.app/verify")
//        actionCodeSettings.handleCodeInApp = true
//        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
//        
//        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings) { error in
//            if let error = error {
//                print("Error sending email link: \(error.localizedDescription)")
//                return
//            }
//            
//            print("Verification email link sent to \(email)")
//            UserDefaults.standard.set(email, forKey: "pendingEmail")
//            
//            self.db.collection("pending_users").document(email).setData([
//                "username": username,
//                "email": email,
//                "type": "student"
//            ]) { err in
//                if let err = err {
//                    print("Error saving pending user: \(err.localizedDescription)")
//                } else {
//                    print("Pending user data saved")
//                }
//            }
//        }
//        return
// MARK: тут раскомментить если без аккаунта
        Auth.auth().signIn(withEmail: email, password: "123456") {
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
                if let data = document?.data(), data["type"] as? String == "student" {
                    // TODO: роутинг на студента
                    self.routingToAssistantLoggedIn()
                    print("Student signed in")
                } else {
                    print("Not a student")
                }
            }
        }
}
    
    func handleSignIn(email: String, link: String, completion: @escaping (Bool) -> Void) {
        if Auth.auth().isSignIn(withEmailLink: link) {
            Auth.auth().signIn(withEmail: email, link: link) { authResult, error in
                if let error = error {
                    print("Error signing in with link: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let user = authResult?.user else {
                    print("No user after signInWithEmailLink")
                    completion(false)
                    return
                }
                
                let uid = user.uid
                
                self.db.collection("pending_users").document(email).getDocument { document, error in
                    guard let data = document?.data() else {
                        print("No pending data for email")
                        completion(false)
                        return
                    }
                    
                    self.db.collection("users").document(uid).setData(data) { err in
                        if let err = err {
                            print("Error saving user data: \(err.localizedDescription)")
                            completion(false)
                        } else {
                            print("User \(email) successfully verified and saved with UID \(uid)")
                            self.db.collection("pending_users").document(email).delete()
                            completion(true)
                        }
                    }
                }
            }
        } else {
            print("Invalid sign-in link")
            completion(false)
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
