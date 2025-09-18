class RootAuthModuleBuilder {
    static func build() -> RootAuthViewController {
        let view = RootAuthViewController()
        let interactor = RootAuthInteractor()
        let router = RootAuthRouter(viewController: view)
        let presenter = RootAuthPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        return view
    }
}
