//
//  AssessmentCustomCell.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 26.09.2025.
//

import UIKit

final class AssessmentCustomCell: UITableViewCell {
    
    static let identifier = "AssessmentCustomCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .clear
        return view
    }()
    
    private let statusIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1)
        return imageView
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1).cgColor
        layer.masksToBounds = true
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(statusView)
        statusView.addSubview(statusIcon)
        statusView.addSubview(numberLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.pinTop(to: contentView.topAnchor, 5)
        titleLabel.pinLeft(to: contentView.leadingAnchor, 5)
        titleLabel.setHeight(20)
        titleLabel.setWidth(300)
        
        dateLabel.pinTop(to: titleLabel.bottomAnchor, 5)
        dateLabel.pinLeft(to: contentView.leadingAnchor, 5)
        dateLabel.setHeight(20)
        dateLabel.setWidth(300)
        
        statusView.pinCenterY(to: contentView)
        statusView.pinRight(to: contentView.trailingAnchor, 20)
        
        statusIcon.pinCenterX(to: statusView)
        statusIcon.pinCenterY(to: statusView)
        statusIcon.setWidth(44)
        statusIcon.setHeight(44)
        
        numberLabel.pinCenterX(to: statusView)
        numberLabel.pinCenterY(to: statusView)
    }
    
    // MARK: - Configuration
    func configure(with title: String, email: String, isClockIcon: Bool, number: Int? = nil) {
        titleLabel.text = title
        dateLabel.text = email
        
        if isClockIcon {
            statusIcon.image = UIImage(systemName: "clock")
            statusIcon.isHidden = false
            numberLabel.isHidden = true
            statusView.backgroundColor = .clear
        } else if let number = number {
            numberLabel.text = "\(number)"
            numberLabel.isHidden = false
            statusIcon.isHidden = true
            statusView.backgroundColor = .systemBlue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
        statusIcon.image = nil
        numberLabel.text = nil
        statusView.backgroundColor = .clear
    }
}
