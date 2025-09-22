import UIKit

class AssistantAuthViewController: UIViewController {
    
    let textLabel = UILabel()
    
    let mailTextField = UITextField()
    let passwordTextField = UITextField()
    
    let loginButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    
    func setUpView() {
        setUpTextLabel()
        setUpTextFields()
        setUpLoginButton()
    }
    
    func setUpTextLabel() {
        textLabel.numberOfLines = 0
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textAlignment = .center
        textLabel.text = "Вход по корпоративной почте,\n пароль запросите у преподавателя"
        textLabel.font = UIFont.systemFont(ofSize: 17)
        textLabel.textColor = .systemGray
        view.addSubview(textLabel)
        textLabel.pinTop(to: view)
        textLabel.pinCenterX(to: view)
    }
    
    func setUpTextFields() {
        
        mailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mailTextField)
        
        mailTextField.borderStyle = .roundedRect
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor.gray]
        let attributedString = NSAttributedString(string: "eikhromova@edu.hse.ru", attributes: attributes)
        mailTextField.attributedPlaceholder = attributedString
        mailTextField.layer.borderWidth = 1
        mailTextField.layer.cornerRadius = 10
        mailTextField.setWidth(300)
        mailTextField.setHeight(40)
        mailTextField.pinTop(to: textLabel.bottomAnchor, 20)
        mailTextField.pinCenterX(to: view)
        
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        
        passwordTextField .borderStyle = .roundedRect
        

        let attributedString2 = NSAttributedString(string: "password", attributes: attributes)
        passwordTextField.attributedPlaceholder = attributedString2
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.setWidth(300)
        passwordTextField.setHeight(40)
        passwordTextField.pinTop(to: mailTextField.bottomAnchor, 15)
        passwordTextField.pinCenterX(to: view)
        
    }
    
    func setUpLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = Constants.Color.primary
        loginButton.layer.cornerRadius = 25
        loginButton.pinCenterX(to: view)
        loginButton.pinTop(to: passwordTextField.bottomAnchor, 50)
        loginButton.setWidth(200)
        loginButton.setHeight(50)
    }
}
