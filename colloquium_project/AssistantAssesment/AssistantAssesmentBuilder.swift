//
//  AssistantAssesmentBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 19.09.2025.
//

import Foundation

class AssistantAssesmentBuilder {
    static func build() -> AssistantAssesmentViewController {
        let view = AssistantAssesmentViewController()
        let interactor = AssistantAssesmentInteractor()
        let presenter = AssistantAssesmentPresenter(view: view, interactor: interactor)
        view.presenter = presenter
        return view
    }
}
