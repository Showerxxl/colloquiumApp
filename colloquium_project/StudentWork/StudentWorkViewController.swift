//
//  AnswerViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 20.09.2025.
//

import UIKit

final class StudentWorkViewController: UIViewController {
    
    private let nameLabel = UILabel()
    private let tableView = UITableView()
    
    private var studentName: String
    private var questions: [String] = [
        "Какие типы данных (различные по хранению в памяти) используются в iOS? Чем отличается стек от кучи?",
        "Как называется \"утечка памяти\" в Swift?",
        "Что такое ARC? Как это работает?",
        "Что означает unowned? Чем это отличается от weak?",
        "Что такое enum? Является ли enum в Swift ссылочным или значим типом?",
        "Почему enum в Swift - это «лучший» enum на сегодняшний день, даже по сравнению с Java?",
        "Как сделать enum десериализуемым?",
        "В чем разница между ассоциированными и присвоенными (raw) значениями?",
        "В чем разница между классами и структурами в Swift?",
        "Что такое lazy свойства в Swift и зачем они нужны?",
        "Что такое Optional? Как он реализован в Swift?",
        "Назовите 4 способа, которыми можно развернуть Optional (превратить Type? в Type)",
        "Что такое COW?",
        "Что такое ключевое слово «final»? Зачем оно нам нужно? Подсказка: не для того, чтобы запрещать наследование",
        "Что такое typealias и зачем он нужен?",
        "Как работает defer в Swift? В каких случаях его использование оправдано?",
        "Что такое диспетчеризация методов в Swift? Назовите 4 типа.",
        "Что такое замыкание в Swift? Когда замыкание захватывает по ссылке а когда по значению"
    ]
    
    init(studentName: String) {
        self.studentName = studentName
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
        nameLabel.text = studentName
        nameLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        
        view.addSubview(nameLabel)
        nameLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, -10)
        nameLabel.pinCenterX(to: view)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 20
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QuestionCell")
        view.addSubview(tableView)
        
        tableView.pinTop(to: nameLabel.bottomAnchor, 20)
        tableView.pinLeft(to: view, 16)
        tableView.pinRight(to: view, 16)
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 0)
    }
}

extension StudentWorkViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        cell.textLabel?.text = questions[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = questions[indexPath.row]
        let vc = AnswerViewController(question: item, answer: "Вот тут будет ответ студента, когда у нас будет сервер", numberOfQuestion: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
}

