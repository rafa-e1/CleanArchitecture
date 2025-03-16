//
//  UserTableViewCell.swift
//  CleanArchitecture
//
//  Created by RAFA on 3/16/25.
//

import UIKit

import Kingfisher

final class UserTableViewCell: UITableViewCell {

    static let id = "UserTableViewCell"

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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(userImageView)
        addSubview(nameLabel)

        userImageView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(20)
            make.size.equalTo(80)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(cellData: UserListCellData) {
        guard case let .user(user, isFavorite) = cellData else { return }

        userImageView.kf.setImage(with: URL(string: user.imageURL))
        nameLabel.text = user.login
    }
}
