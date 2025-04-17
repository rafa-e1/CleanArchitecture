//
//  HeaderTableViewCell.swift
//  CleanArchitecture
//
//  Created by RAFA on 4/17/25.
//

import UIKit

final class HeaderTableViewCell: UITableViewCell, UserListCellProtocol {

    static let id = "HeaderTableViewCell"

    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(cellData: UserListCellData) {
        guard case let .header(title) = cellData else { return }

        titleLabel.text = title
    }
}
