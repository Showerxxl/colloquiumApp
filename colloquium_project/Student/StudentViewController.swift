import UIKit


class StudentViewController: UIViewController, StudentViewProtocol {
    
    let nameTextField = UITextField()
    let cameraImage1 = UIImageView()
    let cameraImage2 = UIImageView()
    
    let cameraButton1 = UIButton()
    let cameraButton2 = UIButton()
    
    let loginButton = UIButton()
    
    
    var presenter : StudentPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .green
        
        setUpView()
    }
    
    
    func setUpView() {
        setUpTextField()
        setUpPhotoViews()
        setUpPhotoButtons()
        setUpLoginButton()
    }
    
    private func setUpPhotoViews() {
        view.addSubview(cameraImage1)
        cameraImage1.translatesAutoresizingMaskIntoConstraints = false
        cameraImage1.image = UIImage(named: "cameraman")
        cameraImage1.pinTop(to: nameTextField.bottomAnchor, 40)
        cameraImage1.pinLeft(to: nameTextField.leadingAnchor)
        cameraImage1.setWidth(25)
        cameraImage1.setHeight(25)
        
        view.addSubview(cameraImage2)
        cameraImage2.translatesAutoresizingMaskIntoConstraints = false
        cameraImage2.image = UIImage(named: "cameraman")
        cameraImage2.pinTop(to: cameraImage1.bottomAnchor, 40)
        cameraImage2.pinLeft(to: nameTextField.leadingAnchor)
        cameraImage2.setWidth(25)
        cameraImage2.setHeight(25)
    }
    
    
    private func setUpPhotoButtons() {
        view.addSubview(cameraButton1)
        cameraButton1.translatesAutoresizingMaskIntoConstraints = false
        cameraButton1.setTitle("Ваше селфи", for: .normal)
        cameraButton1.contentHorizontalAlignment = .left
        cameraButton1.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cameraButton1.setTitleColor(.gray, for: .normal)
        cameraButton1.pinTop(to: nameTextField.bottomAnchor, 40)
        cameraButton1.pinLeft(to: cameraImage1.trailingAnchor, 20)
        cameraButton1.setWidth(300)
        cameraButton1.setHeight(25)
        
        view.addSubview(cameraButton2)
        cameraButton2.translatesAutoresizingMaskIntoConstraints = false
        cameraButton2.setTitle("Фото студенческого билета", for: .normal)
        cameraButton2.contentHorizontalAlignment = .left
        cameraButton2.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cameraButton2.setTitleColor(.gray, for: .normal)
        cameraButton2.pinTop(to: cameraButton1.bottomAnchor, 40)
        cameraButton2.pinLeft(to: cameraImage2.trailingAnchor, 20)
        cameraButton2.setWidth(300)
        cameraButton2.setHeight(25)
        
        cameraButton1.addTarget(self, action: #selector(handleSelfieButton), for: .touchUpInside)
        cameraButton2.addTarget(self, action: #selector(handleDocumentButton), for: .touchUpInside)
    }
    
    @objc private func handleSelfieButton() {
        presenter?.didTapOnPhotoButton(for: .selfie)
    }
    
    @objc private func handleDocumentButton() {
        presenter?.didTapOnPhotoButton(for: .document)
    }
    
    @objc private func handleTextField() {
        
    }
    
    private func setUpLoginButton() {
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = Constants.Color.primary
        loginButton.layer.cornerRadius = 25
        loginButton.pinCenterX(to: view)
        loginButton.pinTop(to: cameraButton2.bottomAnchor, 50)
        loginButton.setWidth(200)
        loginButton.setHeight(50)
        
        
    }
    
    private func setUpTextField() {
   
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        nameTextField.borderStyle = .roundedRect
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle, .foregroundColor: UIColor.gray]
        let attributedString = NSAttributedString(string: "Хромова Елизавета Ивановна", attributes: attributes)
        nameTextField.attributedPlaceholder = attributedString
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 10
        nameTextField.setWidth(300)
        nameTextField.setHeight(40)
        nameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        nameTextField.pinCenterX(to: view)
        nameTextField.addTarget(self, action: #selector(handleTextField), for: .touchUpInside)
        
    }
}
