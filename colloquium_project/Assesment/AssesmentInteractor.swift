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
    
    func getData() {
        var studentsToMark: [Student : Int?] = [:]
        studentsToMark[Student(id: "1", username: "Григорьев В.", email: "vgrigoriev@edu.hse.ru")] = nil
        studentsToMark[Student(id: "2", username: "Шварева А. А.", email: "aashvareva@edu.hse.ru")] = nil
        studentsToMark[Student(id: "3", username: "Хромова Е. И.", email: "eikhromova@edu.hse.ru")] = 2
        studentsToMark[Student(id: "4", username: "Тепляков В. В.", email: "vvteplyakov@edu.hse.ru")] = 10
        studentsToMark[Student(id: "5", username: "Кажкаримов А. А.", email: "aakazhkarimov@edu.hse.ru")] = 8
        studentsToMark[Student(id: "6", username: "Новгородский А. А.", email: "aanovgorodskiy@edu.hse.ru")] = 6
        studentsToMark[Student(id: "7", username: "Кучеренко В. Н.", email: "vnkucherenko@edu.hse.ru")] = 9
        studentsToMark[Student(id: "8", username: "Садикова Е. А.", email: "easadikova@edu.hse.ru")] = 10
        // TODO: getting data from firebase
        presenter.showData(title: "", date: "", students: studentsToMark)
        print(studentsToMark.count)
    }
}
