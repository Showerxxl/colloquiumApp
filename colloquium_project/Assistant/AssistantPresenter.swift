//
//  AssistantPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 19.09.2025.
//

import Foundation

final class AssistantPresenter: AssistantPresenterProtocol {
    weak var view: AssistantViewController?
    var interactor: AssistantInteractorProtocol
    
    init(view: AssistantViewController, interactor: AssistantInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
}
