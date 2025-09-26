//
//  AssistantStartInteractor.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import Foundation
import FirebaseFirestore

final class AssistantStartInteractor: AssistantStartInteractionLogic {
    private let presenter: AssistantStartPresentationLogic
    private var students: [Student] = []
    
    init(presenter: AssistantStartPresentationLogic) {
        self.presenter = presenter
    }
    
    func routingToAssistantAccount() {
        presenter.routingToAssistantAccount()
    }
    
    func routingToChooseStudents() {
        fetchStudents { [weak self] students, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
            } else if let students = students {
                print("Загрузили студентов: \(students.count)")
                self?.presenter.routingToChooseStudents(students: students)
            }
        }
    }
    
    private func fetchStudents(completion: @escaping ([Student]?, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("users")
            .whereField("type", isEqualTo: "student")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let students: [Student] = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let username = data["username"] as? String,
                        let email = data["email"] as? String
                    else {
                        return nil
                    }
                    
                    return Student(id: doc.documentID,
                                   username: username,
                                   email: email)
                } ?? []
                
                completion(students, nil)
            }
    }
    
    func routingToAssesment() {
        presenter.routingToAssesment()
    }
}
