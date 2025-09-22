//
//  AnswerViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 20.09.2025.
//

import UIKit

final class AnswerViewController: UIViewController {
    
    private let questionContainer = UIView()
    private let questionLabel = UILabel()
    private let answerLabel = UILabel()
    private let answerContainer = UILabel()
    private let numberLabel = UILabel()
    private let basicAnswerLabel = UILabel()
    
    private var question: String
    private var answer: String
    private var number: Int
    
    init(question: String, answer: String, numberOfQuestion: Int) {
        self.question = question
        self.answer = answer
        self.number = numberOfQuestion
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1)
        configureUI()
    }
    
    private func configureUI() {
        configureNumberLabel()
        configureQuestion()
        configureAnswerLabel()
        configureAnswer()
    }
    
    private func configureNumberLabel() {
        numberLabel.text = "Вопрос " + String(number + 1)
        numberLabel.font = UIFont.systemFont(ofSize: 20)
        numberLabel.textAlignment = .center
        numberLabel.textColor = .black
        
        view.addSubview(numberLabel)
        
        numberLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        numberLabel.pinCenterX(to: view)
    }
    
    private func configureQuestion() {
        questionContainer.backgroundColor = .white
        questionContainer.layer.cornerRadius = 20
        questionContainer.layer.masksToBounds = true
        
        view.addSubview(questionContainer)
        questionContainer.pinTop(to: numberLabel.bottomAnchor, 15)
        questionContainer.pinRight(to: view, 20)
        questionContainer.pinLeft(to: view, 20)
        
        questionLabel.text = question
        questionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        questionLabel.textColor = .black
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        
        questionContainer.addSubview(questionLabel)
        questionLabel.pinTop(to: questionContainer.topAnchor, 12)
        questionLabel.pinLeft(to: questionContainer.leadingAnchor, 12)
        questionLabel.pinRight(to: questionContainer.trailingAnchor, 12)
        questionLabel.pinBottom(to: questionContainer.bottomAnchor, 12)
    }
    
    private func configureAnswerLabel() {
        basicAnswerLabel.text = "Ответ"
        basicAnswerLabel.font = UIFont.systemFont(ofSize: 20)
        basicAnswerLabel.textAlignment = .center
        basicAnswerLabel.textColor = .black
        
        view.addSubview(basicAnswerLabel)
        
        basicAnswerLabel.pinTop(to: questionContainer.bottomAnchor, 20)
        basicAnswerLabel.pinCenterX(to: view)
    }
    
    private func configureAnswer() {
        answerContainer.backgroundColor = .white
        answerContainer.layer.cornerRadius = 20
        answerContainer.layer.masksToBounds = true
        
        view.addSubview(answerContainer)
        answerContainer.pinTop(to: basicAnswerLabel.bottomAnchor, 20)
        answerContainer.pinRight(to: view, 20)
        answerContainer.pinLeft(to: view, 20)
        
        answerLabel.text = answer
        answerLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        answerLabel.textColor = .black
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .center
        
        answerContainer.addSubview(answerLabel)
        answerLabel.pinTop(to: answerContainer.topAnchor, 12)
        answerLabel.pinLeft(to: answerContainer.leadingAnchor, 12)
        answerLabel.pinRight(to: answerContainer.trailingAnchor, 12)
        answerLabel.pinBottom(to: answerContainer.bottomAnchor, 12)
    }
}
