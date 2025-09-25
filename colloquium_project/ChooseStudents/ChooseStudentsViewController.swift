//
//  ChooseStudentsViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import UIKit

final class ChooseStudentsViewController: UIViewController {
    private let interactor: ChooseStudentsInteractionLogic
    private let students: [Student]
    
    private let chooseStudentsLabel = UILabel()
    private let tableView = UITableView()
    private var selectedStudents: Set<String> = []
    private let startButton = UIButton(type: .system)
    
    init(interactor: ChooseStudentsInteractionLogic, students: [Student]) {
        self.interactor = interactor
        self.students = students
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideBackButton()
        configureUI()
    }
    
    private func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func configureUI() {
        configureChooseStudentsLabel()
        configureStartNewAssesmentButton()
        configureStudentsTableView()
    }
    
    private func configureChooseStudentsLabel() {
        chooseStudentsLabel.text = "Выберите студентов для прохождения тестрирования:"
        chooseStudentsLabel.numberOfLines = 0
        chooseStudentsLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        chooseStudentsLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        chooseStudentsLabel.textAlignment = .left
        
        view.addSubview(chooseStudentsLabel)
        chooseStudentsLabel.pinTop(to: view, 80)
        chooseStudentsLabel.pinLeft(to: view, 25)
        chooseStudentsLabel.pinRight(to: view, 25)
    }
    
    private func configureStudentsTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChooseStudentCustomCell.self, forCellReuseIdentifier: ChooseStudentCustomCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: chooseStudentsLabel.bottomAnchor, 10)
        tableView.pinBottom(to: startButton.topAnchor, 10)
        tableView.pinRight(to: view.trailingAnchor, 20)
        tableView.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureStartNewAssesmentButton() {
        startButton.backgroundColor = UIColor(red: 1.0, green: 184.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitle("Начать тестирование", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        startButton.layer.cornerRadius = 20
        startButton.layer.masksToBounds = true
        
        view.addSubview(startButton)
        
        startButton.pinBottom(to: view, 40)
        startButton.setHeight(57)
        startButton.pinCenterX(to: view)
        startButton.setWidth(331)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func startButtonTapped() {
        
    }
}

extension ChooseStudentsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension ChooseStudentsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return students.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChooseStudentCustomCell.identifier, for: indexPath) as? ChooseStudentCustomCell else {
            return UITableViewCell()
        }

        let student = students[indexPath.section]
        let isSelected = selectedStudents.contains(student.id)
        cell.configure(with: student.username, email: student.email, isSelected: isSelected)

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.section]

        if selectedStudents.contains(student.id) {
            selectedStudents.remove(student.id)
        } else {
            selectedStudents.insert(student.id)
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? ChooseStudentCustomCell {
            let isSelected = selectedStudents.contains(student.id)
            cell.setSelectedState(isSelected)
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}


