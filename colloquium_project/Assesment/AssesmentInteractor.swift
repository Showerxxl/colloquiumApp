//
//  AssesmentInteractor.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import Foundation

final class AssesmentInteractor: AssesmentInteractionLogic {
    
    private let presenter: AssesmentPresentationLogic
    
    init(presenter: AssesmentPresentationLogic) {
        self.presenter = presenter
    }
}
