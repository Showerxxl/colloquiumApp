//
//  QuestionViewController.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import UIKit

// Question VC — has interactor only. Presenter will create and push this VC and then call displayQuestion(...)
final class QuestionViewController: UIViewController {
    private let titleLabel = UILabel()
    private let textView = UITextView()
    private let optionsStack = UIStackView()

    // VIEW -> INTERACTOR only
    var interactor: TestInteractorInput?

    private var currentVM: QuestionViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .done,
            target: self,
            action: #selector(nextTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
    }

    private func setupUI() {
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)

        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor
        textView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        optionsStack.axis = .vertical
        optionsStack.spacing = 8

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))

        let sv = UIStackView(arrangedSubviews: [titleLabel, textView, optionsStack])
        sv.axis = .vertical
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sv)

        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12)
        ])
    }

    // Presenter calls this method to populate view (no protocol)
    func displayQuestion(_ vm: QuestionViewModel) {
        currentVM = vm
        titleLabel.text = "\(vm.index + 1)/\(vm.total). " + vm.title
        if vm.type == .open {
            textView.isHidden = false
            optionsStack.isHidden = true
            textView.text = vm.existingText ?? ""
        } else {
            textView.isHidden = true
            optionsStack.isHidden = false
            buildOptions(vm.options, selected: vm.selectedOptionId)
        }
    }

    private func buildOptions(_ options: [AnswerOption], selected: String?) {
        optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for opt in options {
            let b = UIButton(type: .system)
            b.setTitle(opt.text, for: .normal)
            b.titleLabel?.numberOfLines = 0
            b.contentHorizontalAlignment = .left
            b.layer.borderWidth = 1
            b.layer.cornerRadius = 8
            b.tag = opt.id.hashValue
            b.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            b.backgroundColor = (opt.id == selected) ? UIColor.systemGray5 : .clear
            optionsStack.addArrangedSubview(b)
            b.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        }
    }

    @objc private func optionTapped(_ sender: UIButton) {
//        guard let vm = currentVM else { return }
//        guard let opt = vm.options.first(where: { $0.id.hashValue == sender.tag }) else { return }
//        // View calls interactor to save answer
//        interactor?.saveAnswer(questionId: vm.id, textAnswer: nil, optionId: opt.id)
//        // Update UI highlight
//        for case let b as UIButton in optionsStack.arrangedSubviews { b.backgroundColor = (b.tag == sender.tag) ? UIColor.systemGray5 : .clear }
    }

    @objc private func nextTapped() {
//        guard let vm = currentVM else { return }
//        if vm.type == .open {
//            let txt = textView.text ?? ""
//            if txt.count < vm.minSymbols {
//                let a = UIAlertController(title: "Too short", message: "Минимум символов: \(vm.minSymbols)", preferredStyle: .alert)
//                a.addAction(UIAlertAction(title: "OK", style: .default))
//                present(a, animated: true)
//                // ❌ не делаем return
//            } else {
//                interactor?.saveAnswer(questionId: vm.id, textAnswer: txt, optionId: nil)
//            }
//        }
//        interactor?.goNext()
    }
    
    @objc private func backTapped() {
//        interactor?.goBack()
    }
}
