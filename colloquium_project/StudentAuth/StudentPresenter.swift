import UIKit

class StudentPresenter: StudentPresenterProtocol {
    
    weak var view: StudentViewProtocol?
    var interactor: StudentInteractorProtocol
    var router: StudentRouterProtocol
    
    init(view: StudentViewProtocol, interactor: StudentInteractorProtocol, router: StudentRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        print("StudentPresenter initialized")
    }
    
    func viewDidLoad() {
        print("StudentPresenter viewDidLoad called")
        view?.setUpUI()
    }
    
    func didChangeUsername(_ username: String) {
        print("didChangeUsername called with: \(username)")
        // Поскольку сохранение теперь только при логине, здесь не сохраняем
    }
    
    func performLogin(username: String, email: String) {
        interactor.saveUserData(username: username, email: email)
    }
}
