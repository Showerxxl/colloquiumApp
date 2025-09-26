//
//  AssistantAccountViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import UIKit

final class AssistantAccountViewController: UIViewController {
    
    private let interactor: AssistantAccountInteractionLogic
    
    private let nameLabel = UILabel()
    private var name: String?
    private let emailLabel = UILabel()
    private var email: String?
    private let exitButton = UIButton(type: .system)
    private var checkedWorksLabel = UILabel()
    private var checkedWorks: [String] = []
    private let sleepyImageView = UIImageView()
    private let sleepyLabel = UILabel()
    
    init(interactor: AssistantAccountInteractionLogic) {
        self.interactor = interactor
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
    
    func loadUserData(loadingName: String, loadingEmail: String) {
        name = loadingName
        email = loadingEmail
    }
    
    private func hideBackButton() {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func configureUI() {
        interactor.getUserData()
        configureNameLabel()
        configureEmailLabel()
        configureExitButton()
        configureCheckedWorksLabel()
        configureCheckedWorksTableView()
    }
    
    private func configureNameLabel() {
        nameLabel.text = name
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        nameLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        nameLabel.textAlignment = .left
        
        view.addSubview(nameLabel)
        nameLabel.pinTop(to: view, 80)
        nameLabel.pinLeft(to: view, 25)
        nameLabel.pinRight(to: view, 25)
    }
    
    private func configureEmailLabel() {
        emailLabel.text = email
        emailLabel.numberOfLines = 0
        emailLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        emailLabel.textColor = UIColor(hex: "F19EDC")
        emailLabel.textAlignment = .left
        
        view.addSubview(emailLabel)
        emailLabel.pinTop(to: nameLabel.bottomAnchor, 5)
        emailLabel.pinLeft(to: view, 25)
        emailLabel.pinRight(to: view, 25)
    }
    
    private func configureExitButton() {
        view.addSubview(exitButton)
        exitButton.setTitle("Выйти", for: .normal)
        exitButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        exitButton.setTitleColor(.black, for: .normal)
        exitButton.backgroundColor = UIColor(red: 1.0, green: 184.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        exitButton.layer.cornerRadius = 25
        exitButton.pinCenterX(to: view)
        exitButton.pinBottom(to: view, 40)
        exitButton.setWidth(200)
        exitButton.setHeight(50)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
    }
    
    private func configureCheckedWorksLabel() {
        checkedWorksLabel.text = "Проверенные работы"
        checkedWorksLabel.numberOfLines = 0
        checkedWorksLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        checkedWorksLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        checkedWorksLabel.textAlignment = .left
        
        view.addSubview(checkedWorksLabel)
        checkedWorksLabel.pinTop(to: emailLabel.bottomAnchor, 40)
        checkedWorksLabel.pinLeft(to: view, 25)
        checkedWorksLabel.pinRight(to: view, 25)
    }
    
    @objc
    private func exitButtonTapped() {
        interactor.logOut()
    }
    
    private func configureCheckedWorksTableView() {
        // TODO: getting works from firebase and tableview
        if checkedWorks.isEmpty {
            configureSleepyFace()
            configureSleepyLabel()
        }
    }
    
    private func configureSleepyFace() {
        let sleepyImage = UIImage(named: "Sleepy")
        sleepyImageView.image = sleepyImage
        
        view.addSubview(sleepyImageView)
        sleepyImageView.pinTop(to: checkedWorksLabel.bottomAnchor, 30)
        sleepyImageView.pinCenterX(to: view)
        sleepyImageView.setWidthRelativeToScreen()
        sleepyImageView.heightAnchor.constraint(equalTo: sleepyImageView.widthAnchor).isActive = true
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
}

extension AssistantAccountViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

