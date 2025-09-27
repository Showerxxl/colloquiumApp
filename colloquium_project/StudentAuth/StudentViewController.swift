import UIKit

class StudentViewController: UIViewController, StudentViewProtocol, UITextFieldDelegate {
    
    var presenter: StudentPresenterProtocol?
    
    private let nameTextField = UITextField()
    private let mailTextField = UITextField()
    private let loginButton = UIButton()
    private let infoLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setUpUI() {
        setUpTextField()
        setUpMailTextField()
        setUpLoginButton()
    }
    
    func updateUI(with userData: UserData) {
        nameTextField.text = userData.username
    }
    
    @objc private func handleTextField() {
        presenter?.didChangeUsername(nameTextField.text ?? "")
    }
    
    private func setUpMailTextField() {
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailTextField)
        
        mailTextField.borderStyle = .roundedRect
        mailTextField.textColor = UIColor(hex: "A8A8A8")
        mailTextField.autocapitalizationType = .none
        mailTextField.keyboardType = .emailAddress
        mailTextField.returnKeyType = .next
        mailTextField.delegate = self
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor(hex: "A8A8A8")]
        let attributedString = NSAttributedString(string: "@edu.hse.ru", attributes: attributes)
        mailTextField.attributedPlaceholder = attributedString
        mailTextField.backgroundColor = .white
        mailTextField.layer.borderColor = UIColor(hex: "A8A8A8").cgColor
        mailTextField.font = UIFont.systemFont(ofSize: 20)
        mailTextField.layer.borderWidth = 1
        mailTextField.autocorrectionType = .no
        mailTextField.spellCheckingType = .no
        mailTextField.layer.cornerRadius = 10
        mailTextField.pinRight(to: view, 25)
        mailTextField.pinLeft(to: view, 25)
        mailTextField.setHeight(40)
        mailTextField.pinTop(to: nameTextField.bottomAnchor, 20)
        mailTextField.pinCenterX(to: view)
    }
    
    private func setUpLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = Constants.Color.primary
        loginButton.layer.cornerRadius = 25
        loginButton.pinCenterX(to: view)
        loginButton.pinTop(to: mailTextField.bottomAnchor, 35)
        loginButton.setWidth(200)
        loginButton.setHeight(50)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc private func handleLogin() {
        // TODO: вот тут надо сразу высвечивать сообщение пользователю о том, что данные не полные и не давать нажать на кнопку
        let username = nameTextField.text ?? ""
        let email = mailTextField.text ?? ""
        presenter?.performLogin(username: username, email: email)
        configureInfoLabel()
    }
    
    private func configureInfoLabel() {
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.text = "На вашу почту отправлена ссылка-подтверждение. Перейдите по ней, чтобы войти"
        infoLabel.font = UIFont.systemFont(ofSize: 20)
        infoLabel.textColor = UIColor(hex: "A8A8A8")
        view.addSubview(infoLabel)
        infoLabel.pinTop(to: loginButton.bottomAnchor, 15)
        infoLabel.pinLeft(to: view, 15)
        infoLabel.pinRight(to: view, 15)
    }
    
    private func setUpTextField() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        nameTextField.borderStyle = .roundedRect
        nameTextField.layer.borderColor = UIColor(hex: "A8A8A8").cgColor
        nameTextField.textColor = UIColor(hex: "A8A8A8")
        nameTextField.backgroundColor = .white
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor(hex: "A8A8A8")]
        let attributedString = NSAttributedString(string: "ФИО", attributes: attributes)
        nameTextField.attributedPlaceholder = attributedString
        nameTextField.font = UIFont.systemFont(ofSize: 20)
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 10
        nameTextField.setHeight(40)
        nameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 20)
        nameTextField.pinCenterX(to: view)
        nameTextField.pinLeft(to: view, 25)
        nameTextField.pinRight(to: view, 25)
        nameTextField.addTarget(self, action: #selector(handleTextField), for: .touchUpInside)
        
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
