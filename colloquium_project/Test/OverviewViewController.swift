//
//  OverviewViewController.swift
//  colloquium_project
//
//  Created by Vladimir Grigoryev on 20.09.2025.
//

import UIKit

final class OverviewViewController: UIViewController {
    private let table = UITableView()
    private let timerLabel = UILabel()

    // VIEW -> INTERACTOR only (protocol)
    var interactor: TestInteractorInput?

    private var questionTitles: [String] = []
    
    private let finishButton: UIButton = {
        let b = UIButton(type: .system)
        
        b.setTitle("Завершить", for: .normal)
        b.tintColor = .white
        b.backgroundColor = .red
        b.layer.cornerRadius = 18
        b.titleLabel?.font = .systemFont(ofSize: 23, weight: .regular)
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "FFDEF9")
        setupUI()
        // debug helpers:
        table.isUserInteractionEnabled = true
        table.backgroundColor = .systemBackground
        view.bringSubviewToFront(table)
        print("Overview viewDidLoad — table frame: \(table.frame), superview: \(String(describing: table.superview))")
        interactor?.loadTest()
    }

    private func setupUI() {
        timerLabel.font = UIFont.systemFont(ofSize: 28)
        timerLabel.textAlignment = .center
        
        finishButton.setWidth(149)
        finishButton.setHeight(40)
        finishButton.layer.cornerRadius = 20
        finishButton.addTarget(self, action: #selector(finishTapped), for: .touchUpInside)

        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        table.layer.cornerRadius = 20

//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishTapped))

        [timerLabel, finishButton, table].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 78),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            finishButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 73),
            finishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            table.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 28),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }

    @objc private func finishTapped() {
//        interactor?.finishTest()
        print("Finish tapped")
    }

    // Methods Presenter calls directly on the concrete view (no protocol)
    func displayOverview(title: String, questions: [String], remainingSeconds: Int) {
        self.questionTitles = questions
        table.reloadData()
        updateTimer(remaining: remainingSeconds)
    }

    func updateTimer(remaining: Int) {
        let m = (remaining % 3600) / 60
        let s = remaining % 60
        timerLabel.text = String(format: "%02d:%02d", m, s)
    }
}

extension OverviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ t: UITableView, numberOfRowsInSection section: Int) -> Int { questionTitles.count }
    func tableView(_ t: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = t.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        c.textLabel?.numberOfLines = 2
        c.textLabel?.text = "\(indexPath.row + 1). " + questionTitles[indexPath.row]
        c.accessoryType = .disclosureIndicator
        return c
    }
    
    func tableView(_ t: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt: \(indexPath.row)")
//        t.deselectRow(at: indexPath, animated: true)
//        interactor?.selectQuestion(index: indexPath.row)
    }
}
