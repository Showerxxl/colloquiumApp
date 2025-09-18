import UIKit

class RootAuthViewController: UIViewController, RootAuthViewProtocol {
    
    private let studentButton = UIButton(type: .system)
    private let assistantButton = UIButton(type: .system)
    
    private let contentContainer = UIView()
    private let headerView = UIView()
    private let bodyView = UIView()
    
    var presenter: RootAuthPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    // MARK: - RootAuthViewProtocol
    func setUpUI() {
        setUpMainScreen()
        setUpContainerView()
        setUpHeaderView()
        setUpBodyView()
        setupButtons()
    }
    
    func setUpMainScreen() {
        view.backgroundColor = Constants.Color.primary
        setUpName()
    }

    func setUpName() {
        let iosLabel = UILabel()
        iosLabel.translatesAutoresizingMaskIntoConstraints = false
        iosLabel.font = UIFont.systemFont(ofSize: 90)
        iosLabel.text = "iOS"
        iosLabel.textColor = .white
        view.addSubview(iosLabel)
        iosLabel.pinTop(to: view, 80)
        iosLabel.pinCenterX(to: view)
        
        
        
        let colLabel = UILabel()
        colLabel.translatesAutoresizingMaskIntoConstraints = false
        colLabel.font = UIFont(name: "PlaywriteUSTrad-Regular", size: 40)
        colLabel.text = "colloquium"
        view.addSubview(colLabel)
        colLabel.pinCenterX(to: view)
        colLabel.pinBottom(to: iosLabel, -15)
        
    }

    
    func updateButtonStyle(for role: Role) {
        func styleSelectedButton(_ button: UIButton) {
            button.backgroundColor = Constants.Color.primary
            button.tintColor = .black
        }
        
        func styleUnselectedButton(_ button: UIButton) {
            button.backgroundColor = .white
            button.layer.borderColor = Constants.Color.primary.cgColor
            button.layer.borderWidth = 2
            button.tintColor = .black
        }
        
        if role == .student {
            styleSelectedButton(studentButton)
            styleUnselectedButton(assistantButton)
        } else {
            styleSelectedButton(assistantButton)
            styleUnselectedButton(studentButton)
        }
    }
    
    func getContainerView() -> UIView {
        return bodyView
    }
    
    // MARK: - Private UI Setup
    private func setUpContainerView() {
        contentContainer.backgroundColor = .white
        view.addSubview(contentContainer)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.pinBottom(to: view)
        contentContainer.pinLeft(to: view)
        contentContainer.pinRight(to: view)
        contentContainer.pinTop(to: view, 300) // Изменено с pinTop(to: view, 300) для большей высоты
        
        contentContainer.layer.cornerRadius = 30.0
        contentContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentContainer.layer.masksToBounds = true
    }
    
    private func setUpHeaderView() {
        contentContainer.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.pinLeft(to: contentContainer)
        headerView.pinRight(to: contentContainer)
        headerView.pinTop(to: contentContainer)
        headerView.setHeight(70)
    }
    
    private func setUpBodyView() {
        contentContainer.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.pinLeft(to: contentContainer)
        bodyView.pinRight(to: contentContainer)
        bodyView.pinTop(to: headerView.bottomAnchor)
        bodyView.pinBottom(to: contentContainer)
    }
    
    private func setupButtons() {
        studentButton.setTitle("Студент", for: .normal)
        studentButton.backgroundColor = Constants.Color.primary
        studentButton.tintColor = .black
        studentButton.layer.cornerRadius = 10
        
        headerView.addSubview(studentButton)
        studentButton.translatesAutoresizingMaskIntoConstraints = false
        studentButton.setWidth(170)
        studentButton.setHeight(45)
        studentButton.pinTop(to: headerView, 15)
        studentButton.pinLeft(to: headerView, 15)
        
        assistantButton.translatesAutoresizingMaskIntoConstraints = false
        assistantButton.setTitle("Ассистент", for: .normal)
        assistantButton.backgroundColor = .white
        assistantButton.layer.borderColor = Constants.Color.primary.cgColor
        assistantButton.layer.borderWidth = 2
        assistantButton.tintColor = .black
        assistantButton.layer.cornerRadius = 10
        
        headerView.addSubview(assistantButton)
        assistantButton.setWidth(170)
        assistantButton.setHeight(45)
        assistantButton.pinTop(to: headerView, 15)
        assistantButton.pinRight(to: headerView, 15)
        
        studentButton.addTarget(self, action: #selector(handleStudentButton), for: .touchUpInside)
        assistantButton.addTarget(self, action: #selector(handleAssistantButton), for: .touchUpInside)
    }
    
    @objc private func handleStudentButton() {
        presenter?.didTapButton(for: .student)
    }
    
    @objc private func handleAssistantButton() {
        presenter?.didTapButton(for: .assistant)
    }
}
