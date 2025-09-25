//
//  ChooseStudentsInteractor.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import Foundation
import FirebaseFirestore

final class ChooseStudentsInteractor: ChooseStudentsInteractionLogic {
    private let presenter: ChooseStudentsPresentationLogic
    private var students: [Student] = []
    
    init(presenter: ChooseStudentsPresentationLogic) {
        self.presenter = presenter
    }
}
