//
//  StartTestCodeVC.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 23.09.2025.
//

import UIKit

final class StartTestCodeVC: UIViewController {
    var interactor: StartTestCodeInteractorInput?
    
    // MARK: - UI
    
    private let codeField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 22
        tf.clipsToBounds = true
        tf.placeholder = "Введите код"
        tf.font = .systemFont(ofSize: 17)
        tf.keyboardType = .numberPad
        tf.textContentType = .oneTimeCode
        tf.clearButtonMode = .whileEditing
        tf.clearButtonMode = .never
        tf.rightViewMode = .always
        return tf
    }()
    
    private let sendButton: UIButton = {
        let b = UIButton(type: .system)
        
        let cfg = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .default)
        let img = UIImage(systemName: "arrow.right", withConfiguration: cfg)
        b.setImage(img, for: .normal)
        
        b.tintColor = UIColor(hex: "F19EDC")
        b.layer.cornerRadius = 18
        b.isEnabled = false
        b.alpha = 0.0
        return b
    }()
    
    private lazy var textStack: UIStackView = {
        let s = UIStackView(arrangedSubviews: [
            paragraph("После входа на коллоквиум, вы увидите таймер обратного отсчёта или экран ожидания, если преподаватель ещё не запустил коллоквиум."),
            paragraph("Вы можете возвращаться к вопросам, пока не закончится таймер или вы не завершите сдачу коллоквиума."),
            paragraph("Вы сможете узнать результаты после проверки всех работ ассистентами.")
        ])
        s.axis = .vertical
        s.spacing = 24
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "FFDEF9")
        setupUI()
        setupRightView()
        setupHandlers()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(codeField)
        view.addSubview(textStack)
        
        // паддинг слева у textField
        codeField.setLeftPadding(16)
        
        let g = view.safeAreaLayoutGuide
        
        codeField.pinTop(to: g.topAnchor, 24)
        codeField.pinLeft(to: g.leadingAnchor, 20)
        codeField.pinRight(to: g.trailingAnchor, 20)
        codeField.setHeight(57)
        
        textStack.pinTop(to: codeField.bottomAnchor, 32)
        textStack.pinLeft(to: g.leadingAnchor, 28)
        textStack.pinRight(to: g.trailingAnchor, 28)
    }
    
    private func setupRightView() {
        // контейнер rightView
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        sendButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(sendButton)

        container.setWidth(56)
        container.setHeight(57)
        
        sendButton.setWidth(32)
        sendButton.setHeight(32)
        sendButton.pinCenterX(to: container.centerXAnchor)
        sendButton.pinCenterY(to: container.centerYAnchor)

        // назначаем как rightView
        codeField.rightView = container
        codeField.rightViewMode = .always
    }
    
    private func setupHandlers() {
        codeField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        sendButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        codeField.inputAccessoryView = makeAccessoryToolbar()
    }
    
    private func paragraph(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = text
        l.numberOfLines = 0
        l.textAlignment = .center
        l.font = .systemFont(ofSize: 16)
        l.textColor = .label
        return l
    }
    
    private func makeAccessoryToolbar() -> UIToolbar {
        let tb = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 44))
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(dismissKeyboard))
        tb.items = [flex, done]
        return tb
    }
    
    @objc private func textChanged() {
        // оставляем только цифры и режем до 6 символов
        let digitsOnly = (codeField.text ?? "").filter { $0.isNumber }
        let limited = String(digitsOnly.prefix(6))
        if codeField.text != limited {
            codeField.text = limited
        }
        let isValid = limited.count == 6
        sendButton.isEnabled = isValid
        UIView.animate(withDuration: 0.2) {
            self.sendButton.alpha = isValid ? 1.0 : 0.0
        }
    }
    
    @objc private func submit() {
        let code = String((codeField.text ?? "").filter { $0.isNumber }.prefix(6))
        guard code.count == 6 else { return }
        view.endEditing(true)
        interactor?.onSumbitCode(code: code)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

private extension UITextField {
    func setLeftPadding(_ width: CGFloat) {
        let v = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
        leftView = v
        leftViewMode = .always
    }
}
