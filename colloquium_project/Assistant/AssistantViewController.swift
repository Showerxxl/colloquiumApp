//
//  AssistantViewController.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 19.09.2025.
//

import UIKit

final class AssistantViewController: UIViewController {
    
    var presenter: AssistantPresenterProtocol?
    
    private let startButton = UIButton(type: .system)
    private let listLabel: UILabel = UILabel()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = true
        return tableView
    }()
    private var items: [(title: String, date: String, isChecked: Bool, number: Int?)] = [
        ("Григорьев В.", "18.09.2025", false, nil),
        ("Шварева А. А.", "18.09.2025", true, 8),
        ("Хромова Е. И.", "18.09.2025", false, nil),
        ("Тепляков В. В.", "18.09.2025", true, 10),
        ("Кажкаримов А. А.", "22.09.2024", true, 5),
        ("Новгородский А. А.", "22.09.2024", false, nil),
        ("Кучеренко В. Н.", "22.09.2024", true, 6),
        ("Садикова Е. А.", "22.09.2024", true, 3)
    ]
    private let codeLabel = UILabel()
    private let timerLabel = UILabel()
    private var countdownTimer: Timer?
    private var remainingSeconds = 3600
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
    }
    
    private func configureUI() {
        configureStartColloquiumButton()
        configureListLabel()
        configureTableView()
        configureCodeAndTimerLabels()
    }
    
    private func configureStartColloquiumButton() {
        startButton.backgroundColor = UIColor(red: 1.0, green: 184.0/255.0, blue: 242.0/255.0, alpha: 1.0)
        startButton.setTitleColor(.white, for: .normal)
        startButton.setTitle("Начать коллоквиум", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        startButton.layer.cornerRadius = 12
        startButton.layer.masksToBounds = true
        
        view.addSubview(startButton)
        
        startButton.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        startButton.setHeight(57)
        startButton.pinCenterX(to: view)
        startButton.setWidth(331)
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
               
    // TODO: добавить что при нажатии начинается обратный отсчет и появляется код доступа
    @objc
    private func startButtonTapped() {
        startButton.isHidden = true
                
        let code = String(format: "%06d", Int.random(in: 0...999999))
        codeLabel.text = "Код: \(code)"
        codeLabel.isHidden = false
        timerLabel.isHidden = false
        
        startCountdown()
    }
    
    private func startCountdown() {
        countdownTimer?.invalidate()
        remainingSeconds = 3600
        updateTimerLabel()
        
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.remainingSeconds -= 1
            self.updateTimerLabel()
            
            if self.remainingSeconds <= 0 {
                timer.invalidate()
                self.timerLabel.text = "Время вышло!"
            }
        }
    }
    
    private func updateTimerLabel() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        timerLabel.text = String(format: "Оставшееся время: %02d:%02d", minutes, seconds)
    }
    
    private func configureListLabel() {
        listLabel.text = "Сданные работы"
        listLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        listLabel.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        listLabel.textAlignment = .left
        
        view.addSubview(listLabel)
        
        listLabel.pinTop(to: startButton.bottomAnchor, 30)
        listLabel.pinLeft(to: view, 20)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AssistantCustomCell.self, forCellReuseIdentifier: AssistantCustomCell.identifier)
        
        view.addSubview(tableView)
        
        tableView.pinTop(to: listLabel.bottomAnchor, 10)
        tableView.pinBottom(to: view.bottomAnchor, 10)
        tableView.pinRight(to: view.trailingAnchor, 20)
        tableView.pinLeft(to: view.leadingAnchor, 20)
    }
    
    private func configureCodeAndTimerLabels() {
        codeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 36, weight: .bold)
        codeLabel.textColor = .black
        codeLabel.textAlignment = .center
        codeLabel.isHidden = true
        view.addSubview(codeLabel)
        codeLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
        codeLabel.pinCenterX(to: view)
        
        timerLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        timerLabel.textColor = .darkGray
        timerLabel.textAlignment = .center
        timerLabel.isHidden = true
        view.addSubview(timerLabel)
        timerLabel.pinTop(to: codeLabel.bottomAnchor, 8)
        timerLabel.pinCenterX(to: view)
    }
}

extension AssistantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AssistantCustomCell.identifier, for: indexPath) as? AssistantCustomCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.section]
        cell.configure(with: item.title, date: item.date, isClockIcon: item.isChecked, number: item.number)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let student = items[indexPath.section]
        
        let vc = StudentWorkViewController(studentName: student.title)
        navigationController?.pushViewController(vc, animated: true)
    }
}
