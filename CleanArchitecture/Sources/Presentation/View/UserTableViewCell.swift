//
//  UserTableViewCell.swift
//  CleanArchitecture
//
//  Created by RAFA on 3/16/25.
//

import UIKit

import Kingfisher
import RxSwift

final class UserTableViewCell: UITableViewCell {

    static let id = "UserTableViewCell"

    var disposeBag = DisposeBag()

    private let userImageView = {
        let imageView = UIImageView()
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 2
        return label
    }()

    let favoriteButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemRed
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(userImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(favoriteButton)

        userImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(80).priority(.high)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }

        favoriteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(-20)
            make.size.equalTo(40)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(cellData: UserListCellData) {
        guard case let .user(user, isFavorite) = cellData else { return }

        userImageView.kf.setImage(with: URL(string: user.imageURL))
        nameLabel.text = user.login
        favoriteButton.isSelected = isFavorite
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}
