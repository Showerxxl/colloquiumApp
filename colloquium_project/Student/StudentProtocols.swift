import UIKit

enum Types {
    case selfie
    case document
}

protocol StudentViewProtocol : AnyObject {
    func setUpView()
}

protocol StudentPresenterProtocol {
    func viewDidLoad()
    func didTapOnPhotoButton(for type: Types)

}

protocol StudentRouterProtocol {
    
}

protocol StudentInteractorProtocol {
    
}

