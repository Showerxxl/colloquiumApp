import UIKit

class StudentViewController: UIViewController, StudentViewProtocol, UITextFieldDelegate {  // Добавлен UITextFieldDelegate
    
    let nameTextField = UITextField()
    let cameraImage1 = UIImageView()
    let cameraImage2 = UIImageView()
    
    let cameraButton1 = UIButton()
    let cameraButton2 = UIButton()
    
    let loginButton = UIButton()
    
    var presenter: StudentPresenterProtocol?
    
    var currentImageSource: ImageSource?
    
    var tempPhoto1: UIImage?
    var tempPhoto2: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
        // Добавляем жест для скрытия клавиатуры при тапе на экран
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    func setUpUI() {
        setUpTextField()
        setUpPhotoViews()
        setUpPhotoButtons()
        setUpLoginButton()
    }
    
    func updateUI(with userData: UserData) {
        nameTextField.text = userData.username
        if let photo1Url = userData.photo1Url {
            presenter?.loadImage(fromUrl: photo1Url) { image in
                self.cameraImage1.image = image ?? UIImage(named: "cameraman")
            }
        } else {
            cameraImage1.image = UIImage(named: "cameraman")
        }
        
        if let photo2Url = userData.photo2Url {
            presenter?.loadImage(fromUrl: photo2Url) { image in
                self.cameraImage2.image = image ?? UIImage(named: "cameraman")
            }
        } else {
            cameraImage2.image = UIImage(named: "cameraman")
        }
    }
    
    func updateTempImage(_ image: UIImage, for source: ImageSource) {
        if source == .camera1 {
            tempPhoto1 = image
            cameraImage1.image = image
        } else {
            tempPhoto2 = image
            cameraImage2.image = image
        }
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
        presenter?.didTapCameraImage1()
    }
    
    @objc private func handleDocumentButton() {
        presenter?.didTapCameraImage2()
    }
    
    @objc private func handleTextField() {
        presenter?.didChangeUsername(nameTextField.text ?? "")
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
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
    
    @objc private func handleLogin() {
        let username = nameTextField.text ?? ""
        presenter?.performLogin(username: username, photo1: tempPhoto1, photo2: tempPhoto2)
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
        
        // Добавляем делегата для обработки Enter
        nameTextField.delegate = self
        nameTextField.returnKeyType = .done  // Опционально: меняет Enter на Done
    }
    
    // Метод для скрытия клавиатуры при тапе
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    // Делегат для скрытия клавиатуры при Enter
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    
}


extension StudentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            presenter?.didSelectImage(image, for: currentImageSource ?? .camera1)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
