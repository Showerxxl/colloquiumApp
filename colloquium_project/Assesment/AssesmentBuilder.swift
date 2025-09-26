//
//  AssesmentBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import Foundation

final class AssesmentBuilder {
    static func build(title: String, date: String) -> AssesmentViewController {
        let presenter = AssesmentPresenter()
        let interactor = AssesmentInteractor(presenter: presenter)
        let view = AssesmentViewController(interactor: interactor, title: title, date: date)
        presenter.view = view
        return view
    }
}
