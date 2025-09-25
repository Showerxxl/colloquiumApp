//
//  ChooseStudentsCustomCell.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import UIKit

final class ChooseStudentCustomCell: UITableViewCell {
    
    static let identifier = "ChooseStudentCustomCell"
    
    private let backgroundFillView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1)
        label.numberOfLines = 1
        return label
    }()

    private(set) var isChecked: Bool = false

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(backgroundFillView)
        backgroundFillView.frame = contentView.bounds.insetBy(dx: -2, dy: -2)
        backgroundFillView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailLabel)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        layer.masksToBounds = true
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
    }

    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailLabel)

        titleLabel.pinLeft(to: contentView, 15)
        titleLabel.pinTop(to: contentView, 10)
        titleLabel.pinRight(to: contentView, 15)

        emailLabel.pinLeft(to: contentView, 15)
        emailLabel.pinTop(to: titleLabel.bottomAnchor, 4)
        emailLabel.pinRight(to: contentView, 15)
        emailLabel.pinBottom(to: contentView, 10)
    }

    @objc
    private func toggleCheckmark() {
        isChecked.toggle()
        updateCheckUI()
    }

    private func updateCheckUI() {
        if isChecked {
            contentView.backgroundColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 0.3)
        } else {
            contentView.backgroundColor = .clear
        }
    }

    func configure(with username: String, email: String, isSelected: Bool = false) {
        titleLabel.text = username
        emailLabel.text = email
        isChecked = isSelected
        backgroundFillView.backgroundColor = isChecked
        ? UIColor(red: 241/255, green: 158/255, blue: 220/255, alpha: 0.3)
            : .clear
    }
    
    func setSelectedState(_ selected: Bool) {
        isChecked = selected
        backgroundFillView.backgroundColor = selected
        ? UIColor(red: 241/255, green: 158/255, blue: 220/255, alpha: 0.3)
            : .clear
    }
}
