//
//  AssistantStartPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation

final class AssistantStartPresenter: AssistantStartPresentationLogic {
    weak var view: AssistantStartViewController?
    
    func routingToAssistantAccount() {
        let vc = AssistantAccountBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routingToChooseStudents(students: [Student]) {
        let vc = ChooseStudentsBuilder.build(students: students)
        view?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func routingToAssesment() {
        let vc = AssesmentBuilder.build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }
}
