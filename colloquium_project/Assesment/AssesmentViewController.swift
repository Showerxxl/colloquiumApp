//
//  AssesmentViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import UIKit

final class AssesmentViewController: UIViewController {
    
    private let interactor: AssesmentInteractionLogic
    private let title_: String
    private let date: String
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let tableView = UITableView()
    private var studentsToMark: [Student : Int?] = [:]
    private var studentsKeys: [Student] = []
    
    init(interactor: AssesmentInteractionLogic, title: String, date: String) {
        self.interactor = interactor
        self.title_ = title
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    func loadData(title: String, date: String, students: [Student : Int?]) {
        // TODO: load data
        studentsToMark = students
        studentsKeys = Array(students.keys)
        tableView.reloadData()
    }
    
    private func configureUI() {
        hideBackButton()
        configureTitleLabel()
        configureDateLabel()
        configureTableView()
    }
    
    private func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func configureTitleLabel() {
        titleLabel.text = title_
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        titleLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view, 80)
        titleLabel.pinLeft(to: view, 25)
        titleLabel.pinRight(to: view, 25)
    }
    
    private func configureDateLabel() {
        dateLabel.text = date
        dateLabel.numberOfLines = 0
        dateLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        dateLabel.textColor = UIColor(hex: "F19EDC")
        dateLabel.textAlignment = .center
        
        view.addSubview(dateLabel)
        dateLabel.pinTop(to: titleLabel.bottomAnchor, 5)
        dateLabel.pinLeft(to: view, 25)
        dateLabel.pinRight(to: view, 25)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AssessmentCustomCell.self, forCellReuseIdentifier: AssessmentCustomCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: dateLabel.bottomAnchor, 10)
        tableView.pinBottom(to: view.bottomAnchor, 10)
        tableView.pinRight(to: view.trailingAnchor, 20)
        tableView.pinLeft(to: view.leadingAnchor, 20)
        interactor.getData()
    }
}

extension AssesmentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension AssesmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssessmentCustomCell.identifier, for: indexPath) as? AssessmentCustomCell else {
            return UITableViewCell()
        }
        
        guard indexPath.section < studentsKeys.count else {
            return cell
        }
        let student = studentsKeys[indexPath.section]
        let mark = studentsToMark[student] ?? nil
   
        cell.configure(
            with: student.username,
            email: student.email,
            isClockIcon: mark == nil,
            number: mark
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return studentsKeys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section < studentsKeys.count else { return }
        let student = studentsKeys[indexPath.section]
        
        let vc = StudentWorkViewController(studentName: student.username)
        navigationController?.pushViewController(vc, animated: true)
    }
}
