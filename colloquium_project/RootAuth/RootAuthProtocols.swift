import UIKit

enum Role {
    case student
    case assistant
}


protocol RootAuthViewProtocol: AnyObject {
    func setUpUI()
    func updateButtonStyle(for role: Role)
    func getContainerView() -> UIView
}

protocol RootAuthPresenterProtocol {
    func viewDidLoad()
    func didTapButton(for role: Role)
    
}

protocol RootAuthInteractorProtocol {
    func selectRole(_ role: Role)
    func getCurrentRole() -> Role
    func getCurrentViewController() -> UIViewController?
    func setCurrentViewController(_ viewController: UIViewController)
}


protocol RootAuthRouterProtocol {
    func createStudentViewController() -> UIViewController
    func createAssistantViewController() -> UIViewController
    func switchToViewController(from fromVC: UIViewController?, to toVC: UIViewController, role: Role, in container: UIView, completion: @escaping () -> Void)
}
