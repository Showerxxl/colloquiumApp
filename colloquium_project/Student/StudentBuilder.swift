import UIKit

class StudentModuleBuilder {
    static func build() -> StudentViewController {
        let view = StudentViewController()
        let interactor = StudentInteractor()
        let router = StudentRouter(viewController: view)
        let presenter = StudentPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
}
