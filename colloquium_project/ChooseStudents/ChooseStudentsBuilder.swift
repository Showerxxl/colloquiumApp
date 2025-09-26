//
//  ChooseStudentsBuilder.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import Foundation

final class ChooseStudentsBuilder {
    static func build(students: [Student]) -> ChooseStudentsViewController {
        let presenter = ChooseStudentsPresenter()
        let interactor = ChooseStudentsInteractor(presenter: presenter)
        let view = ChooseStudentsViewController(interactor: interactor, students: students)
        presenter.view = view
        return view
    }
}
