//
//  AssistantAuthBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

final class AssistantAuthBuilder {
    static func build() -> AssistantAuthViewController {
        let presenter = AssistantAuthPresenter()
        let interactor = AssistantAuthInteractor(presenter: presenter)
        let view = AssistantAuthViewController(interactor: interactor)
        presenter.view = view
        return view
    }
}
