//
//  AssistantStartViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 24.09.2025.
//

import UIKit

final class AssistantStartViewController: UIViewController {
    private let interactor: AssistantStartInteractionLogic
    private let listLabel = UILabel()
    private let tableView = UITableView()
    private var items: [(title: String, date: String)] = [
        ("iOS Colloquium 2022", "24.12.2022"),
        ("iOS Colloquium 2023", "24.12.2023"),
        ("iOS Colloquium 2024", "24.12.2024"),
        ("iOS Colloquium 2025", "24.12.2025")
    ]
    private let startButton = UIButton(type: .system)
    
    private let accountButton = UIButton(type: .system)
    
    init(interactor: AssistantStartInteractionLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureAccountButton()
        configureListLabel()
        configureStartNewAssesmentButton()
        configureTableView()
    }
    
    private func configureAccountButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .default)
        let image = UIImage(systemName: "person.circle", withConfiguration: largeConfig)
        accountButton.setImage(image, for: .normal)
        accountButton.tintColor = UIColor(hex: "F19EDC")
        accountButton.sizeToFit()
        accountButton.addTarget(self, action: #selector(accountButtonTapped), for: .touchUpInside)
        view.addSubview(accountButton)
        accountButton.pinTop(to: view, 80)
        accountButton.pinRight(to: view, 25)
    }
    
    @objc
    private func accountButtonTapped() {
        interactor.routingToAssistantAccount()
    }
    
    private func configureListLabel() {
        listLabel.text = "Завершенные тестрирования"
        listLabel.numberOfLines = 0
        listLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        listLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        listLabel.textAlignment = .left
        
        view.addSubview(listLabel)
        listLabel.pinTop(to: view, 70)
        listLabel.pinLeft(to: view, 25)
        listLabel.pinRight(to: view, 25)
    }
    
    private func configureStartNewAssesmentButton() {
        startButton.backgroundColor = UIColor(red: 1.0, green: 184.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitle("Начать тестирование", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        startButton.layer.cornerRadius = 12
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
        // TODO: touting to thr screen with students list
    }
    
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AssistantStartCustomCell.self, forCellReuseIdentifier: AssistantStartCustomCell.identifier)
        
        view.addSubview(tableView)
        tableView.pinTop(to: listLabel.bottomAnchor, 10)
        tableView.pinBottom(to: startButton.topAnchor, 10)
        tableView.pinRight(to: view.trailingAnchor, 20)
        tableView.pinLeft(to: view.leadingAnchor, 20)
    }
}

extension AssistantStartViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssistantStartCustomCell.identifier, for: indexPath) as? AssistantStartCustomCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.section]
        cell.configure(with: item.title, date: item.date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let student = items[indexPath.section]
        // TODO: routing to screen with list of students' works
        let vc = StudentWorkViewController(studentName: student.title)
        navigationController?.pushViewController(vc, animated: true)
    }
}
