//
//  ChooseStudentsPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import Foundation

final class ChooseStudentsPresenter: ChooseStudentsPresentationLogic {
    weak var view: ChooseStudentsViewController?
    
    func routingToAssistantAssesment() {
        let vc = AssistantAssesmentBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
