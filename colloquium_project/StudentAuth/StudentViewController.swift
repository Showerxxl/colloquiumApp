import UIKit

class StudentViewController: UIViewController, StudentViewProtocol, UITextFieldDelegate {
    
    var presenter: StudentPresenterProtocol?
    var currentImageSource: ImageSource?
    
    private let nameTextField = UITextField()
    private let cameraImage1 = UIImageView()
    private let cameraImage2 = UIImageView()
    private let cameraButton1 = UIButton()
    private let cameraButton2 = UIButton()
    private let loginButton = UIButton()
    private var tempPhoto1: UIImage?
    private var tempPhoto2: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        
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
        cameraImage1.image = UIImage(systemName: "camera")
        cameraImage1.pinTop(to: nameTextField.bottomAnchor, 40)
        cameraImage1.pinLeft(to: nameTextField.leadingAnchor, 10)
        cameraImage1.setWidth(35)
        cameraImage1.setHeight(30)
        cameraImage1.tintColor = UIColor(hex: "F19EDC")
        
        view.addSubview(cameraImage2)
        cameraImage2.translatesAutoresizingMaskIntoConstraints = false
        cameraImage2.image = UIImage(systemName: "camera")
        cameraImage2.pinTop(to: cameraImage1.bottomAnchor, 40)
        cameraImage2.pinLeft(to: nameTextField.leadingAnchor, 10)
        cameraImage2.setWidth(35)
        cameraImage2.setHeight(30)
        cameraImage2.tintColor = UIColor(hex: "F19EDC")
    }
    
    
    private func setUpPhotoButtons() {
        view.addSubview(cameraButton1)
        cameraButton1.translatesAutoresizingMaskIntoConstraints = false
        cameraButton1.setTitle("Ваше селфи", for: .normal)
        cameraButton1.contentHorizontalAlignment = .left
        cameraButton1.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cameraButton1.setTitleColor(UIColor(hex: "A8A8A8"), for: .normal)
        cameraButton1.pinCenterY(to: cameraImage1)
        cameraButton1.pinLeft(to: cameraImage1.trailingAnchor, 20)
        cameraButton1.setWidth(300)
        cameraButton1.setHeight(25)
        
        view.addSubview(cameraButton2)
        cameraButton2.translatesAutoresizingMaskIntoConstraints = false
        cameraButton2.setTitle("Фото студенческого билета", for: .normal)
        cameraButton2.contentHorizontalAlignment = .left
        cameraButton2.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cameraButton2.setTitleColor(UIColor(hex: "A8A8A8"), for: .normal)
        cameraButton2.pinCenterY(to: cameraImage2)
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
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 22)
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
        nameTextField.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 10)
        nameTextField.pinCenterX(to: view)
        nameTextField.pinLeft(to: view, 15)
        nameTextField.pinRight(to: view, 15)
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
