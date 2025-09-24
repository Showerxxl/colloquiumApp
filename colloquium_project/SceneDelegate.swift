import UIKit
import FirebaseAuth
import SwiftData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        if let user = Auth.auth().currentUser {
            let windowController = RootAuthModuleBuilder.build()
            let navigationController = UINavigationController(rootViewController: windowController)
            window.rootViewController = navigationController
//            // TODO: вот тут добавить проверку студент или ассистент когда появится опция студента
//            let windowController = AssistantBuilder.build()
//            let navigationController = UINavigationController(rootViewController: windowController)
//            window.rootViewController = navigationController
        } else {
            let windowController = RootAuthModuleBuilder.build()
            let navigationController = UINavigationController(rootViewController: windowController)
            window.rootViewController = navigationController
        }
        
        window.makeKeyAndVisible()
    }
    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let incomingURL = userActivity.webpageURL {
            
            let link = incomingURL.absoluteString
            print("Got link: \(link)")
            
            let email = UserDefaults.standard.string(forKey: "pendingEmail") ?? ""
            
            let interactor = StudentInteractor()
            interactor.handleSignIn(email: email, link: link) { success in
                if success {
                // TODO: вот тут должно открываться что-то связанное со студентом, но пока этого нет и открывается ассистентсво
                    self.window?.rootViewController = AssistantBuilder.build()
                } else {
                    print("Failed to sign in")
                }
            }
        }
    }


}

