//
//  TestAssembly.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import UIKit

enum TestAssembly {
    static func assembly() -> UIViewController {
        let service = MockTestService()
        let worker = TestWorker(service: service)
        let presenter = TestPresenter()
        let interactor = TestInteractor(worker: worker, output: presenter)

        let overview = OverviewViewController()
        overview.interactor = interactor
        presenter.overviewVC = overview

        presenter.createQuestionVC = { [weak interactor, weak presenter] in
            let qvc = QuestionViewController()
            qvc.interactor = interactor
            presenter?.questionVC = qvc
            return qvc
        }
        
        return overview
    }
}

