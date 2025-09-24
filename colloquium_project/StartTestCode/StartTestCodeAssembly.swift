//
//  StartTestCodeAssembly.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 23.09.2025.
//

import UIKit

enum StartTestCodeAssembly {
    static func assembly() -> UIViewController {
        let vc = StartTestCodeVC()
        let interactor = StartTestCodeInteractor()
        let presenter = StartTestCodePresenter()
        let worker = StartTestCodeWorker()
        
        vc.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.vc = vc
        
        return vc
    }
}
