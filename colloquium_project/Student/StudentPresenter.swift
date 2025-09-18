class StudentPresenter : StudentPresenterProtocol {
    
    weak var view: StudentViewProtocol?
    var interactor: StudentInteractorProtocol
    var router: StudentRouterProtocol
    
    init(view: StudentViewProtocol, interactor: StudentInteractorProtocol, router: StudentRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.setUpView()
    }
    
    func didTapOnPhotoButton(for type: Types) {
        
    }
    


    
}
