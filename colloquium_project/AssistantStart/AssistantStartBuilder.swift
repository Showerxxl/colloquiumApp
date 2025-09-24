//
//  AssistantStartBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

final class AssistantStartBuilder {
    static func build() -> AssistantStartViewController {
        let presenter = AssistantStartPresenter()
        let interactor = AssistantStartInteractor(presenter: presenter)
        let view = AssistantStartViewController(interactor: interactor)
        presenter.view = view
        return view
    }
}
