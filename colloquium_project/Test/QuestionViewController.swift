//
//  QuestionViewController.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import UIKit

// Question VC — has interactor only. Presenter will create and push this VC and then call displayQuestion(...)
final class QuestionViewController: UIViewController, UITextViewDelegate {
    private let titleLabel = UILabel()
    private let textView = NoPasteTextView()
    private let optionsStack = UIStackView()
    private let timerLabel = UILabel()
    private let placeholderLabel = UILabel()
    private let questionCounterLabel = UILabel()
    private let backButton: UIButton = {
        let b = UIButton(type: .system)
        
        let cfg = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .default)
        let img = UIImage(systemName: "arrow.left", withConfiguration: cfg)
        b.setImage(img, for: .normal)
        
        b.tintColor = UIColor(hex: "000000")
        return b
    }()
    private var didAppearOnce = false

    // VIEW -> INTERACTOR only
    var interactor: TestInteractorInput?

    private var currentVM: QuestionViewModel?
    
    private let nextButton: UIButton = {
        let b = UIButton(type: .system)
        
        let cfg = UIImage.SymbolConfiguration(pointSize: 40, weight: .regular, scale: .default)
        let img = UIImage(systemName: "arrow.right", withConfiguration: cfg)
        b.setImage(img, for: .normal)
        
        b.tintColor = UIColor(hex: "000000")
        return b
    }()
    
    private let showOverviewButton: UIButton = {
        let b = UIButton(type: .system)
        
        let cfg = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .default)
        let img = UIImage(systemName: "list.bullet", withConfiguration: cfg)
        b.setImage(img, for: .normal)
        
        b.tintColor = UIColor(hex: "000000")
        return b
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppearOnce = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "FFDEF9")
        
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    private func setupUI() {
        timerLabel.font = UIFont.systemFont(ofSize: 28)
        timerLabel.textAlignment = .left
        
        questionCounterLabel.font = .systemFont(ofSize: 20, weight: .regular)
        questionCounterLabel.textColor = .label
        
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 20, weight: .regular)
        
        let titleView = makeLabelOnWhiteView(label: titleLabel)

        // 1) СНАЧАЛА настраиваем отступы и скругления
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.cornerRadius = 30
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 0
        textView.layer.borderColor = UIColor.secondaryLabel.cgColor

        // 2) Плейсхолдер
        placeholderLabel.text = "Введите ответ…"
        placeholderLabel.textColor = .placeholderText
        placeholderLabel.font = textView.font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addSubview(placeholderLabel)

        // 3) Констрейнты плейсхолдера с учётом инкрустов
        let inset = textView.textContainerInset
        NSLayoutConstraint.activate([
            placeholderLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: inset.left),
            placeholderLabel.trailingAnchor.constraint(lessThanOrEqualTo: textView.trailingAnchor, constant: -inset.right),
            placeholderLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: inset.top)
        ])

        // Минимальная высота (если нужно)
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 254).isActive = true

        // Делегат, чтобы скрывать/показывать плейсхолдер
        textView.delegate = self

        // Изначальное состояние
        updatePlaceholderVisibility()

        optionsStack.axis = .vertical
        optionsStack.spacing = 8
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        showOverviewButton.addTarget(self, action: #selector(showOverviewTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        showOverviewButton.translatesAutoresizingMaskIntoConstraints = false
        
        let leftSpacer = UIView()
        let rightSpacer = UIView()
        let hStack = UIStackView(arrangedSubviews: [leftSpacer, questionCounterLabel, rightSpacer])
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .equalCentering

        let sv = UIStackView(arrangedSubviews: [timerLabel, hStack, titleView, textView, optionsStack])
        sv.axis = .vertical
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.distribution = .fill
        view.addSubview(sv)
        
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 254).isActive = true

        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.cornerRadius = 30
        textView.layer.masksToBounds = true
        
        view.addSubview(showOverviewButton)
        view.addSubview(backButton)
        view.addSubview(nextButton)

        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            sv.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            sv.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            showOverviewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            showOverviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 33),
            nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -33)
        ])
    }

    // Presenter calls this method to populate view (no protocol)
    func displayQuestion(_ vm: QuestionViewModel) {
        let prevIndex = currentVM?.index
        let isSameIndex = (prevIndex == vm.index)

        // 1) Если это тот же вопрос (нажатие опции) — без слайд-анимации
        if isSameIndex {
            apply(vm, optimizeSameQuestion: true)   // см. перегрузку apply ниже
            currentVM = vm
            return
        }

        // 2) Анимация только когда индекс изменился (Next/Back)
        let dir: CGFloat = (vm.index > (prevIndex ?? vm.index)) ? 1 : -1
        if didAppearOnce {
            animateSwap(direction: dir) { [weak self] in
                self?.apply(vm, optimizeSameQuestion: false)
            }
        } else {
            apply(vm, optimizeSameQuestion: false)
        }
        currentVM = vm
    }
    
    func updateTimer(remaining: Int) {
        let m = (remaining % 3600) / 60
        let s = remaining % 60
        timerLabel.text = String(format: "%02d:%02d", m, s)
        
        if remaining <= 0 {
            interactor?.finishTest()
        }
    }
    
    private func animateSwap(direction: CGFloat, _ updates: @escaping () -> Void) {
        // direction: +1 = Next (влево), -1 = Back (вправо)
        let dx: CGFloat = 24 * direction
        let group = UIStackView(arrangedSubviews: []) // просто контейнер для кода ниже
        let targets = [titleLabel, textView, optionsStack]

        // исходное состояние
        targets.forEach {
            $0.alpha = 0
            $0.transform = CGAffineTransform(translationX: dx, y: 0)
        }

        updates() // перестроили текст/опции

        UIView.animate(withDuration: 0.22,
                       delay: 0,
                       options: [.curveEaseInOut, .allowAnimatedContent],
                       animations: {
            targets.forEach {
                $0.alpha = 1
                $0.transform = .identity
            }
        })
    }
    
    private func updatePlaceholderVisibility() {
        let isEmpty = textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        placeholderLabel.isHidden = !isEmpty || textView.isHidden
    }
    
    func textViewDidChange(_ textView: UITextView) { updatePlaceholderVisibility() }
    func textViewDidBeginEditing(_ textView: UITextView) { updatePlaceholderVisibility() }
    func textViewDidEndEditing(_ textView: UITextView) { updatePlaceholderVisibility() }
    
    private func apply(_ vm: QuestionViewModel, optimizeSameQuestion: Bool) {
        questionCounterLabel.text = "Вопрос \(vm.index + 1)"
        titleLabel.text = vm.title
        backButton.isEnabled  = vm.isBackEnabled
        nextButton.isEnabled = vm.isNextEnabled
        backButton.alpha = vm.isBackEnabled ? 1.0 : 0.3
        nextButton.alpha = vm.isNextEnabled ? 1.0 : 0.3

        switch vm.type {
        case .open:
            textView.isHidden = false
            optionsStack.isHidden = true
            textView.text = vm.existingText ?? ""
            updatePlaceholderVisibility()

        default:
            textView.isHidden = true
            optionsStack.isHidden = false

            if optimizeSameQuestion,
               let prev = currentVM,
               prev.id == vm.id,
               prev.options.map(\.id) == vm.options.map(\.id) {
                // Тот же вопрос и тот же набор опций — просто обновляем подсветку
                updateOptionsSelection(selected: vm.selectedOptionId, animated: true)
            } else {
                // Новый вопрос или изменился набор опций — перестраиваем
                buildOptions(vm.options, selected: vm.selectedOptionId)
            }
        }
    }

    private func updateOptionsSelection(selected: String?, animated: Bool) {
        let update: () -> Void = { [weak self] in
            guard let self = self else { return }
            for case let b as UIButton in self.optionsStack.arrangedSubviews {
                if let sel = selected, let id = b.accessibilityIdentifier {
                    let isSelected = (id == sel)
                    b.backgroundColor = isSelected ? UIColor.systemGray5 : .clear
                    continue
                }

                if let sel = selected {
                    let isSelected = (b.tag == sel.hashValue)
                    b.backgroundColor = isSelected ? UIColor.systemGray5 : .clear
                } else {
                    b.backgroundColor = .clear
                }
            }
        }

        if animated {
            UIView.animate(withDuration: 0.15, animations: update)
        } else {
            update()
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
            b.accessibilityIdentifier = opt.id
            b.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            b.backgroundColor = (opt.id == selected) ? UIColor.systemGray5 : .clear
            optionsStack.addArrangedSubview(b)
            b.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        }
    }
    
    private func makeLabelOnWhiteView(label: UILabel) -> UIView {
        // Контейнер
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 16
        container.layer.masksToBounds = true

        // Лейбл
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.backgroundColor = .clear

        container.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        let inset: CGFloat = 16
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: inset),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -inset),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -inset)
        ])

        // Чтобы стек корректно растягивал по вертикали
        label.setContentCompressionResistancePriority(.required, for: .vertical)

        return container
    }

    @objc private func optionTapped(_ sender: UIButton) {
        guard let vm = currentVM else { return }
        guard let opt = vm.options.first(where: { $0.id.hashValue == sender.tag }) else { return }
        // View calls interactor to save answer
        interactor?.saveAnswer(questionId: vm.id, textAnswer: nil, optionId: opt.id)
        // Update UI highlight
        for case let b as UIButton in optionsStack.arrangedSubviews { b.backgroundColor = (b.tag == sender.tag) ? UIColor.systemGray5 : .clear }
    }

    @objc private func nextTapped() {
        guard let vm = currentVM else { return }
        if vm.type == .open {
            let txt = textView.text ?? ""
            if txt.count < vm.minSymbols {
                let a = UIAlertController(title: "Too short", message: "Минимум символов: \(vm.minSymbols)", preferredStyle: .alert)
                a.addAction(UIAlertAction(title: "OK", style: .default))
                present(a, animated: true)
            } else {
                interactor?.saveAnswer(questionId: vm.id, textAnswer: txt, optionId: nil)
            }
        }
        interactor?.goNext()
    }
    
    @objc private func backTapped() {
        interactor?.goBack()
    }
    
    @objc private func showOverviewTapped() {
        guard let vm = currentVM else { return }

        if vm.type == .open {
            let txt = textView.text ?? ""

            if txt.count < vm.minSymbols {
                let alert = UIAlertController(
                    title: "Too short",
                    message: "Минимум символов: \(vm.minSymbols). Ответ не сохранится(",
                    preferredStyle: .alert
                )

                // Остаться — просто закрывает алерт
                alert.addAction(UIAlertAction(title: "Остаться", style: .cancel, handler: nil))

                // ОК — красная кнопка, уходим на обзор
                alert.addAction(UIAlertAction(title: "ОК", style: .destructive, handler: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }))

                present(alert, animated: true)
                return
            } else {
                interactor?.saveAnswer(questionId: vm.id, textAnswer: txt, optionId: nil)
                navigationController?.popViewController(animated: true)
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
