import UIKit
import AVFoundation
import Photos

class StudentRouter: StudentRouterProtocol {
    weak var viewController: StudentViewController?
    
    init(viewController: StudentViewController) {
        self.viewController = viewController
    }
}
