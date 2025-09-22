//
//  AssistantBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 19.09.2025.
//

import Foundation

class AssistantBuilder {
    static func build() -> AssistantViewController {
        let view = AssistantViewController()
        let interactor = AssistantInteractor()
        let presenter = AssistantPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        return view
    }
}
