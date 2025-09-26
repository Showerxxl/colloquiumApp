//
//  AssistantAssesmentViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 19.09.2025.
//

import UIKit

final class AssistantAssesmentViewController: UIViewController {
    
    var presenter: AssistantAssesmentPresenterProtocol?
    
    private let listLabel: UILabel = UILabel()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    private var items: [(title: String, date: String, isChecked: Bool, number: Int?)] = [
//        ("Григорьев В.", "18.09.2025", false, nil),
//        ("Шварева А. А.", "18.09.2025", true, 8),
//        ("Хромова Е. И.", "18.09.2025", false, nil),
//        ("Тепляков В. В.", "18.09.2025", true, 10),
//        ("Кажкаримов А. А.", "22.09.2024", true, 5),
//        ("Новгородский А. А.", "22.09.2024", false, nil),
//        ("Кучеренко В. Н.", "22.09.2024", true, 6),
//        ("Садикова Е. А.", "22.09.2024", true, 3)
    ]
    private let codeButton = UIButton()
    private let sleepyImageView = UIImageView()
    private let sleepyLabel = UILabel()
    private let finishButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    private func configureUI() {
        hideBackButton()
        configureCodeButton()
        configureListLabel()
        configureTableView()
        configureSleepyFace()
        configureFinishButton()
    }
    
    private func configureListLabel() {
        listLabel.text = "Сданные работы"
        listLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        listLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        listLabel.textAlignment = .left
        
        view.addSubview(listLabel)
        
        listLabel.pinTop(to: codeButton.bottomAnchor, 30)
        listLabel.pinLeft(to: view, 20)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AssistantAssesmentCustomCell.self, forCellReuseIdentifier: AssistantAssesmentCustomCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: listLabel.bottomAnchor, 10)
        tableView.pinBottom(to: view.bottomAnchor, 10)
        tableView.pinRight(to: view.trailingAnchor, 20)
        tableView.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureCodeButton() {
        let code = String(format: "%06d", Int.random(in: 0...999999))
        codeButton.setTitle("Код: \(code)", for: .normal)
        codeButton.titleLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: .bold)
        codeButton.titleLabel?.textColor = .white
        codeButton.backgroundColor = UIColor(hex: "FFB8F2")
        codeButton.layer.cornerRadius = 20
        view.addSubview(codeButton)
        codeButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        codeButton.pinCenterX(to: view)
        codeButton.setWidth(280)
    }
    
    private func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func configureSleepyFace() {
        if !items.isEmpty {
            sleepyLabel.isHidden = true
            sleepyImageView.isHidden = true
        }
        let sleepyImage = UIImage(named: "Sleepy")
        sleepyImageView.image = sleepyImage
        
        view.addSubview(sleepyImageView)
        sleepyImageView.pinTop(to: listLabel.bottomAnchor, 30)
        sleepyImageView.pinCenterX(to: view)
        sleepyImageView.setWidthRelativeToScreen()
        sleepyImageView.heightAnchor.constraint(equalTo: sleepyImageView.widthAnchor).isActive = true
        configureSleepyLabel()
    }
    
    private func configureSleepyLabel() {
        sleepyLabel.text = "Вы пока не проверили ни одной работы"
        sleepyLabel.numberOfLines = 0
        sleepyLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        sleepyLabel.textColor = UIColor(red: 255.0/255.0, green: 184.0/255.0, blue: 241.0/255.0, alpha: 1)
        sleepyLabel.textAlignment = .center
        
        view.addSubview(sleepyLabel)
        sleepyLabel.pinTop(to: sleepyImageView.bottomAnchor, 10)
        sleepyLabel.pinLeft(to: view, 25)
        sleepyLabel.pinRight(to: view, 25)
    }
    
    private func configureFinishButton() {
        view.addSubview(finishButton)
        finishButton.setTitle("Завершить", for: .normal)
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        finishButton.setTitleColor(.white, for: .normal)
        finishButton.backgroundColor = UIColor(red: 1.0, green: 184.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        finishButton.layer.cornerRadius = 25
        finishButton.pinCenterX(to: view)
        finishButton.pinBottom(to: view, 40)
        finishButton.setWidth(200)
        finishButton.setHeight(50)
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func finishButtonTapped() {
        // TODO: finish assesment
    }
}

extension AssistantAssesmentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssistantAssesmentCustomCell.identifier, for: indexPath) as? AssistantAssesmentCustomCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.section]
        cell.configure(with: item.title, date: item.date, isClockIcon: item.isChecked, number: item.number)
        
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
        
        let vc = StudentWorkViewController(studentName: student.title)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AssistantAssesmentViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
