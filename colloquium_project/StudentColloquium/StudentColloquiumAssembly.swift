import UIKit

enum StudentColloquiumAssembly {
    static func make() -> UIViewController {
        let vc = StudentColloquiumViewController()
        let interactor = StudentColloquiumInteractor()
        let presenter = StudentColloquiumPresenter()

        vc.interactor = interactor
        interactor.presenter = presenter
        presenter.view = vc

        return vc
    }
}
