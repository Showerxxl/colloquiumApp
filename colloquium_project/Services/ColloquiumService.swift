//
//  ColloquiumService.swift
//  colloquium_project
//
//  Created by AI Assistant
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol ColloquiumServiceProtocol {
    func fetchColloquia(completion: @escaping (Result<[Colloquium], Error>) -> Void)
    func fetchColloquium(id: String, completion: @escaping (Result<Colloquium?, Error>) -> Void)
    func fetchQuestions(colloquiumId: String, completion: @escaping (Result<[ColloquiumQuestion], Error>) -> Void)
}

final class ColloquiumService: ColloquiumServiceProtocol {
    private let db = Firestore.firestore()
    
    // Получение всех коллоквиумов
    func fetchColloquia(completion: @escaping (Result<[Colloquium], Error>) -> Void) {
        db.collection("colloquia")
            .order(by: "startsAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                let colloquia = snapshot?.documents.compactMap { Colloquium(from: $0) } ?? []
                DispatchQueue.main.async {
                    completion(.success(colloquia))
                }
            }
    }
    
    // Получение конкретного коллоквиума
    func fetchColloquium(id: String, completion: @escaping (Result<Colloquium?, Error>) -> Void) {
        db.collection("colloquia").document(id).getDocument { snapshot, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            let colloquium = snapshot.map { Colloquium(from: $0) }
            DispatchQueue.main.async {
                completion(.success(colloquium as! Colloquium))
            }
        }
    }
    
    // Получение вопросов коллоквиума
    func fetchQuestions(colloquiumId: String, completion: @escaping (Result<[ColloquiumQuestion], Error>) -> Void) {
        db.collection("colloquia")
            .document(colloquiumId)
            .collection("questions")
            .order(by: "order")
            .getDocuments { snapshot, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                    return
                }
                
                let questions = snapshot?.documents.compactMap { ColloquiumQuestion(from: $0) } ?? []
                DispatchQueue.main.async {
                    completion(.success(questions))
                }
            }
    }
    
    // Создание нового коллоквиума (для админов)
    func createColloquium(title: String, description: String?, startsAt: Date, endsAt: Date, completion: @escaping (Result<String, Error>) -> Void) {
        let colloquiumId = UUID().uuidString
        
        let data: [String: Any] = [
            "title": title,
            "description": description ?? "",
            "startsAt": Timestamp(date: startsAt),
            "endsAt": Timestamp(date: endsAt),
            "isActive": true,
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("colloquia").document(colloquiumId).setData(data) { error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                DispatchQueue.main.async {
                    completion(.success(colloquiumId))
                }
            }
        }
    }
    
    // Добавление вопроса к коллоквиуму
    func addQuestion(colloquiumId: String, question: ColloquiumQuestion, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "order": question.order,
            "type": question.type.rawValue,
            "text": question.text,
            "options": question.options.map { ["id": $0.id, "text": $0.text] },
            "correctOptionIds": question.correctOptionIds ?? [],
            "minSymbols": question.minSymbols
        ]
        
        db.collection("colloquia")
            .document(colloquiumId)
            .collection("questions")
            .document(question.id)
            .setData(data) { error in
                DispatchQueue.main.async {
                    completion(error)
                }
            }
    }
}
