import UIKit

enum Types {
    case selfie
    case document
}

enum ImageSource {
    case camera1
    case camera2
}

struct UserData {
    let username: String
    let type: String
    let photo1Url: String?
    let photo2Url: String?
}

protocol StudentViewProtocol : AnyObject {
    func setUpUI()
    func updateUI(with userData: UserData)
    func updateTempImage(_ image: UIImage, for source: ImageSource)
}

protocol StudentPresenterProtocol {
    func viewDidLoad()
    func didChangeUsername(_ username: String)
    func didTapCameraImage1()
    func didTapCameraImage2()
    func didSelectImage(_ image: UIImage, for source: ImageSource)
    func loadImage(fromUrl urlString: String?, completion: @escaping (UIImage?) -> Void)
    func performLogin(username: String, photo1: UIImage?, photo2: UIImage?)
}

protocol StudentRouterProtocol {
    func presentImageOptions(for source: ImageSource)
}

protocol StudentInteractorProtocol {
    func saveUserData(username: String, photo1: UIImage?, photo2: UIImage?)
    func getUserData(completion: @escaping (UserData?) -> Void)
    func loadImage(fromUrl urlString: String?, completion: @escaping (UIImage?) -> Void)
}
