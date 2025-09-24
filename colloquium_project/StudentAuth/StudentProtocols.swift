import UIKit

struct UserData {
    let username: String
    let type: String
}

protocol StudentViewProtocol : AnyObject {
    func setUpUI()
    func updateUI(with userData: UserData)
}

protocol StudentPresenterProtocol {
    func viewDidLoad()
    func didChangeUsername(_ username: String)
    func performLogin(username: String, email: String)
}

protocol StudentRouterProtocol {
}

protocol StudentInteractorProtocol {
    func saveUserData(username: String, email: String)
    func handleSignIn(email: String, link: String, completion: @escaping (Bool) -> Void)
}
