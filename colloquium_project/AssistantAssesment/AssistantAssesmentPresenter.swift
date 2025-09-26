//
//  AssistantAssesmentPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 19.09.2025.
//

import Foundation

final class AssistantAssesmentPresenter: AssistantAssesmentPresenterProtocol {
    weak var view: AssistantAssesmentViewController?
    var interactor: AssistantAssesmentInteractorProtocol
    
    init(view: AssistantAssesmentViewController, interactor: AssistantAssesmentInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}
