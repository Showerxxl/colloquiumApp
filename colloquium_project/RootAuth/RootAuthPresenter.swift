import UIKit

class RootAuthPresenter: RootAuthPresenterProtocol {
    weak var view: RootAuthViewProtocol?
    var interactor: RootAuthInteractorProtocol
    var router: RootAuthRouterProtocol
    
    init(view: RootAuthViewProtocol, interactor: RootAuthInteractorProtocol, router: RootAuthRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.setUpUI()
        let initialRole = interactor.getCurrentRole()
        let initialVC = initialRole == .student ? router.createStudentViewController() : router.createAssistantViewController()
        interactor.setCurrentViewController(initialVC)
        if let container = view?.getContainerView() {
            router.switchToViewController(from: nil, to: initialVC, role: initialRole, in: container) {
                self.view?.updateButtonStyle(for: initialRole)
            }
        }
    }
    
    func didTapButton(for role: Role) {
        guard role != interactor.getCurrentRole() else { return }
        
        interactor.selectRole(role)
        let toVC = role == .student ? router.createStudentViewController() : router.createAssistantViewController()
        let fromVC = interactor.getCurrentViewController()
        interactor.setCurrentViewController(toVC)
        
        if let container = view?.getContainerView() {
            router.switchToViewController(from: fromVC, to: toVC, role: role, in: container) {
                self.view?.updateButtonStyle(for: role)
            }
        }
    }
}
