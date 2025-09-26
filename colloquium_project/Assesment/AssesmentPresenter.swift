//
//  AssesmentPresenter.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import Foundation

final class AssesmentPresenter: AssesmentPresentationLogic {
    
    weak var view: AssesmentViewController?
    
    func showData(title: String, date: String, students: [Student : Int?]) {
        view?.loadData(title: title, date: date, students: students)
    }
}
