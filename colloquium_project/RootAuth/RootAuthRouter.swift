import UIKit
import SwiftData

class RootAuthRouter: RootAuthRouterProtocol {
   
    weak var viewController: RootAuthViewController?

    
    init(viewController: RootAuthViewController) {
        self.viewController = viewController
    }
    
    func createStudentViewController() -> UIViewController {
        return StudentModuleBuilder.build()
    }
    
    func createAssistantViewController() -> UIViewController {
        return AssistantViewController()
    }
    
    func switchToViewController(from fromVC: UIViewController?, to toVC: UIViewController, role: Role, in container: UIView, completion: @escaping () -> Void) {
        guard let parentVC = viewController else { return }
        if toVC.parent == nil {
            parentVC.addChild(toVC)
            container.addSubview(toVC.view)
            toVC.view.translatesAutoresizingMaskIntoConstraints = false
            toVC.view.pinBottom(to: container.bottomAnchor)
            toVC.view.pinLeft(to: container)
            toVC.view.pinRight(to: container)
            toVC.view.pinTop(to: container.topAnchor)
            toVC.didMove(toParent: parentVC)
        }
        if let fromVC = fromVC {
            fromVC.willMove(toParent: nil)
            fromVC.view.removeFromSuperview()
            fromVC.removeFromParent()
        }
        completion()
    }
    
    func presentCamera() {
        // Реализация для камеры, если требуется
    }
}
