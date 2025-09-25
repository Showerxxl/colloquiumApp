//
//  AssistantAccountBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import Foundation

final class AssistantAccountBuilder {
    static func build() -> AssistantAccountViewController {
        let presenter = AssistantAccountPresenter()
        let interactor = AssistantAccountInteractor(presenter: presenter)
        let view = AssistantAccountViewController(interactor: interactor)
        presenter.view = view
        return view
    }
}
