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
        interactor.getUserData { userData in
            if let userData = userData {
                print("Loaded existing UserData: \(userData.username), type: \(userData.type)")
                self.view?.updateUI(with: userData)
            } else {
                print("No UserData found, initializing empty UI")
                let emptyUserData = UserData(username: "", type: "student", photo1Url: nil, photo2Url: nil)
                self.view?.updateUI(with: emptyUserData)
            }
        }
    }
    
    func didChangeUsername(_ username: String) {
        print("didChangeUsername called with: \(username)")
        // Поскольку сохранение теперь только при логине, здесь не сохраняем
    }
    
    func didTapCameraImage1() {
        print("didTapCameraImage1 called")
        router.presentImageOptions(for: .camera1, isGalleryAllowed: false)
    }
    
    func didTapCameraImage2() {
        print("didTapCameraImage2 called")
        router.presentImageOptions(for: .camera2, isGalleryAllowed: true)
    }
    
    func didSelectImage(_ image: UIImage, for source: ImageSource) {
        print("didSelectImage called for source: \(source)")
        view?.updateTempImage(image, for: source)
    }
    
    func loadImage(fromUrl urlString: String?, completion: @escaping (UIImage?) -> Void) {
        interactor.loadImage(fromUrl: urlString, completion: completion)
    }
    
    func performLogin(username: String, photo1: UIImage?, photo2: UIImage?) {
        interactor.saveUserData(username: username, photo1: photo1, photo2: photo2)
    }
}
