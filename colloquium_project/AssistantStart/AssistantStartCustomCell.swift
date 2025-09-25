//
//  AssistantStartCustomCell.swift
//  colloquium_project
//
//  Created by лизо4ка курунок on 25.09.2025.
//

import UIKit

final class AssistantStartCustomCell: UITableViewCell {
    static let identifier = "AssistantStartCustomCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 115.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 241.0/255.0, green: 158.0/255.0, blue: 220.0/255.0, alpha: 1)
        label.numberOfLines = 1
        return label
    }()
    
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
    }
    
    // MARK: - Configuration
    func configure(with title: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
    }
}

