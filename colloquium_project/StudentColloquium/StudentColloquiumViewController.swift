import UIKit


final class StudentColloquiumViewController: UIViewController {

    var interactor: StudentColloquiumBusinessLogic?

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Мои коллоквиумы"
        l.font = .systemFont(ofSize: 30, weight: .bold)
        l.textColor = UIColor(red: 115/255, green: 64/255, blue: 64/255, alpha: 1)
        l.textAlignment = .left
        return l
    }()

    private let tableView: UITableView = {
        let t = UITableView()
        t.backgroundColor = .clear
        t.separatorStyle = .none
        t.showsVerticalScrollIndicator = true
        return t
    }()

    private let sleepyImageView = UIImageView()
    private let sleepyLabel: UILabel = {
        let l = UILabel()
        l.text = "Вы пока не проходили ни одного коллоквиума"
        l.numberOfLines = 0
        l.font = .systemFont(ofSize: 25, weight: .bold)
        l.textColor = UIColor(red: 255/255, green: 184/255, blue: 241/255, alpha: 1)
        l.textAlignment = .center
        return l
    }()

    private let startButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Начать коллоквиум", for: .normal)
        b.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(red: 1.0, green: 184/255, blue: 242/255, alpha: 1.0) // #FFB8F2
        b.layer.cornerRadius = 25
        return b
    }()

    private var items: [StudentColloquiumModels.History.ItemViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        interactor?.loadHistory()
    }

    private func setupUI() {
        // Навбар и свайп-назад
        navigationItem.backButtonTitle = ""
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true

        // Верхний заголовок
        view.addSubview(titleLabel)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        titleLabel.pinLeft(to: view, 20)

        // Таблица
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StudentColloquiumCell.self, forCellReuseIdentifier: StudentColloquiumCell.identifier)
        view.addSubview(tableView)
        tableView.pinTop(to: titleLabel.bottomAnchor, 10)
        tableView.pinLeft(to: view.leadingAnchor, 20)
        tableView.pinRight(to: view.trailingAnchor, 20)

        // Плашка пустого состояния
        sleepyImageView.image = UIImage(named: "Sleepy")
        view.addSubview(sleepyImageView)
        sleepyImageView.pinTop(to: titleLabel.bottomAnchor, 30)
        sleepyImageView.pinCenterX(to: view)
        sleepyImageView.setWidthRelativeToScreen()
        sleepyImageView.heightAnchor.constraint(equalTo: sleepyImageView.widthAnchor).isActive = true

        view.addSubview(sleepyLabel)
        sleepyLabel.pinTop(to: sleepyImageView.bottomAnchor, 10)
        sleepyLabel.pinLeft(to: view, 25)
        sleepyLabel.pinRight(to: view, 25)

        // Кнопка “Начать”
        view.addSubview(startButton)
        startButton.pinBottom(to: view, 40)
        startButton.pinCenterX(to: view)
        startButton.setWidth(260)
        startButton.setHeight(50)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)

        tableView.pinBottom(to: startButton.topAnchor, 16)
        updateEmptyState(isEmpty: true)
    }

    private func updateEmptyState(isEmpty: Bool) {
        sleepyImageView.isHidden = !isEmpty
        sleepyLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    @objc private func startTapped() {
        interactor?.startButtonTapped()
    }

    // MARK: - DisplayLogic

    func displayHistory(_ viewModel: StudentColloquiumModels.History.ViewModel) {
        self.items = viewModel.items
        tableView.reloadData()
        updateEmptyState(isEmpty: items.isEmpty)
    }

    func navigateToStart() {
        // Подставь свой экран, если он у тебя по-другому называется
        let vc = StartTestCodeAssembly.assembly()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StudentColloquiumViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int { items.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 68 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(); v.backgroundColor = .clear; return v
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StudentColloquiumCell.identifier,
            for: indexPath
        ) as? StudentColloquiumCell else { return UITableViewCell() }

        let vm = items[indexPath.section]
        cell.configure(with: vm)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Позже можно открыть подробности попытки коллоквиума
    }
}
