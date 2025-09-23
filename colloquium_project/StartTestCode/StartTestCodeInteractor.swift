//
//  StartTestCodeInteractor.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 23.09.2025.
//

import Foundation

protocol StartTestCodeInteractorInput {
    func onSumbitCode(code: String)
}

final class StartTestCodeInteractor: StartTestCodeInteractorInput {
    var presenter: StartTestCodeInteractorOutput?
    var worker: StartTestCodeWorkerProtocol?
    
    func onSumbitCode(code: String) {
        print("Interactor code works!")
    }
}
