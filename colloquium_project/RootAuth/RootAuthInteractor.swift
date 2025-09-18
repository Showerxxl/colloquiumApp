import UIKit

class RootAuthInteractor: RootAuthInteractorProtocol {
    private var currentRole: Role = .student
    private var currentViewController: UIViewController?
    
    func selectRole(_ role: Role) {
        currentRole = role
    }
    
    func getCurrentRole() -> Role {
        return currentRole
    }
    
    func getCurrentViewController() -> UIViewController? {
        return currentViewController
    }
    
    func setCurrentViewController(_ viewController: UIViewController) {
        currentViewController = viewController
    }
}
