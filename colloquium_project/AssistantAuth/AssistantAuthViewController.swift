import UIKit

final class AssistantAuthViewController: UIViewController {
    
    let textLabel = UILabel()
    
    let mailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton()
    private let passwordToggleButton = UIButton()
    private var isPasswordVisible = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpPasswordToggle()
    }
    
    private func setUpView() {
        setUpTextLabel()
        setUpTextFields()
        setUpLoginButton()
    }
    
    private func setUpTextLabel() {
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.text = "Вход по корпоративной почте,\n пароль запросите у преподавателя"
        textLabel.font = UIFont.systemFont(ofSize: 17)
        textLabel.textColor = .systemGray
        view.addSubview(textLabel)
        textLabel.pinTop(to: view, 10)
        textLabel.pinCenterX(to: view)
    }
    
    private func setUpTextFields() {
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailTextField)
        
        mailTextField.borderStyle = .roundedRect
        mailTextField.textColor = UIColor(hex: "A8A8A8")
        mailTextField.autocapitalizationType = .none
        mailTextField.keyboardType = .emailAddress
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor.gray]
        let attributedString = NSAttributedString(string: "@edu.hse.ru", attributes: attributes)
        mailTextField.attributedPlaceholder = attributedString
        mailTextField.backgroundColor = .white
        mailTextField.layer.borderColor = UIColor(hex: "A8A8A8").cgColor
        mailTextField.layer.borderWidth = 1
        mailTextField.layer.cornerRadius = 10
        mailTextField.setWidth(300)
        mailTextField.setHeight(40)
        mailTextField.pinTop(to: textLabel.bottomAnchor, 20)
        mailTextField.pinCenterX(to: view)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.textColor = UIColor(hex: "A8A8A8")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        
        let attributedString2 = NSAttributedString(string: "Password", attributes: attributes)
        passwordTextField.backgroundColor = .white
        passwordTextField.layer.borderColor = UIColor(hex: "A8A8A8").cgColor
        passwordTextField.attributedPlaceholder = attributedString2
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.setWidth(300)
        passwordTextField.setHeight(40)
        passwordTextField.pinTop(to: mailTextField.bottomAnchor, 15)
        passwordTextField.pinCenterX(to: view)
    }
    
    private func setUpPasswordToggle() {
        passwordToggleButton.translatesAutoresizingMaskIntoConstraints = false
        passwordToggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        passwordToggleButton.tintColor = UIColor(hex: "F19EDC")
        passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        view.addSubview(passwordToggleButton)
        passwordToggleButton.pinCenterY(to: passwordTextField)
        passwordToggleButton.pinRight(to: passwordTextField.trailingAnchor, 10)
        
        passwordToggleButton.setWidth(30)
        passwordToggleButton.setHeight(30)
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        
        if isPasswordVisible {
            passwordTextField.isSecureTextEntry = false
            passwordToggleButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            passwordTextField.isSecureTextEntry = true
            passwordToggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
        
        let currentText = passwordTextField.text
        passwordTextField.text = currentText
        
        passwordTextField.becomeFirstResponder()
        
        if let text = currentText, let endPosition = passwordTextField.position(from: passwordTextField.beginningOfDocument, offset: text.count) {
            passwordTextField.selectedTextRange = passwordTextField.textRange(from: endPosition, to: endPosition)
        }
    }
    
    private func setUpLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = Constants.Color.primary
        loginButton.layer.cornerRadius = 25
        loginButton.pinCenterX(to: view)
        loginButton.pinTop(to: passwordTextField.bottomAnchor, 50)
        loginButton.setWidth(200)
        loginButton.setHeight(50)
    }
}
