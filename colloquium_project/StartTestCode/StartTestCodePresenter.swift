//
//  StartTestCodePresenter.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 23.09.2025.
//

import UIKit

protocol StartTestCodeInteractorOutput {
    func routeTest()
}

final class StartTestCodePresenter: StartTestCodeInteractorOutput {
    weak var vc: StartTestCodeVC?

    func routeTest() {
        DispatchQueue.main.async {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first else { return }

            let next = TestAssembly.assembly()

            if let nav = window.rootViewController as? UINavigationController {
                nav.setViewControllers([next], animated: true)
            } else {
                let nav = UINavigationController(rootViewController: next)
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        }
    }
}
