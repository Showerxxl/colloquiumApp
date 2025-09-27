import UIKit

final class StudentColloquiumCell: UITableViewCell {

    static let identifier = "StudentColloquiumCell"

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 20, weight: .bold)
        l.textColor = UIColor(red: 115/255, green: 64/255, blue: 64/255, alpha: 1)
        l.numberOfLines = 1
        return l
    }()

    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15, weight: .bold)
        l.textColor = UIColor(red: 241/255, green: 158/255, blue: 220/255, alpha: 1)
        l.numberOfLines = 1
        return l
    }()

    private let statusView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 12
        v.backgroundColor = .clear
        return v
    }()

    private let statusIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = UIColor(red: 241/255, green: 158/255, blue: 220/255, alpha: 1)
        return iv
    }()

    private let trailingLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 25, weight: .bold)
        l.textColor = UIColor(red: 241/255, green: 158/255, blue: 220/255, alpha: 1)
        l.textAlignment = .center
        l.isHidden = true
        return l
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 241/255, green: 158/255, blue: 220/255, alpha: 1).cgColor
        layer.masksToBounds = true
        contentView.frame = contentView.frame.inset(by: .init(top: 8, left: 8, bottom: 8, right: 8))
    }

    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(statusView)
        statusView.addSubview(statusIcon)
        statusView.addSubview(trailingLabel)

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

        trailingLabel.pinCenterX(to: statusView)
        trailingLabel.pinCenterY(to: statusView)
    }

    func configure(with vm: StudentColloquiumModels.History.ItemViewModel) {
        titleLabel.text = vm.title
        dateLabel.text = vm.dateText

        if vm.showClockIcon {
            statusIcon.image = UIImage(systemName: "clock")
            statusIcon.isHidden = false
            trailingLabel.isHidden = true
            statusView.backgroundColor = .clear
        } else {
            trailingLabel.text = vm.trailingText
            trailingLabel.isHidden = false
            statusIcon.isHidden = true
            statusView.backgroundColor = .systemBlue
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dateLabel.text = nil
        statusIcon.image = nil
        trailingLabel.text = nil
        statusView.backgroundColor = .clear
    }
}
