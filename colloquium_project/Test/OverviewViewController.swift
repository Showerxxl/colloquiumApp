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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Test"
        setupUI()
        // debug helpers:
        table.isUserInteractionEnabled = true
        table.backgroundColor = .systemBackground
        view.bringSubviewToFront(table)
        print("Overview viewDidLoad — table frame: \(table.frame), superview: \(String(describing: table.superview))")
        interactor?.loadTest()
    }

    private func setupUI() {
        timerLabel.font = .monospacedDigitSystemFont(ofSize: 14, weight: .regular)
        timerLabel.textAlignment = .center

        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Finish", style: .done, target: self, action: #selector(finishTapped))

        [timerLabel, table].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            timerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            timerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            table.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 8),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func finishTapped() {
        interactor?.finishTest()
    }

    // Methods Presenter calls directly on the concrete view (no protocol)
    func displayOverview(title: String, questions: [String], remainingSeconds: Int) {
        self.title = title
        self.questionTitles = questions
        table.reloadData()
        updateTimer(remaining: remainingSeconds)
    }

    func updateTimer(remaining: Int) {
        let h = remaining / 3600
        let m = (remaining % 3600) / 60
        let s = remaining % 60
        timerLabel.text = String(format: "Осталось: %02d:%02d:%02d", h, m, s)
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
        t.deselectRow(at: indexPath, animated: true)
        interactor?.selectQuestion(index: indexPath.row)
    }
}
