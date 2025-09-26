//
//  AssesmentProtocols.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import Foundation

protocol AssesmentPresentationLogic {
    func showData(title: String, date: String, students: [Student : Int?])
}

protocol AssesmentInteractionLogic {
    func getData()
}
