//
//  UserListViewController.swift
//  CleanArchitecture
//
//  Created by RAFA on 3/7/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class UserListViewController: UIViewController {

    // MARK: - Properties

    private let searchTextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.cornerRadius = 6
        textField.placeholder = "검색어를 입력해 주세요."
        let image = UIImageView(image: .init(systemName: "magnifyingglass"))
        image.frame = .init(x: 0, y: 0, width: 20, height: 20)
        textField.leftView = image
        textField.leftViewMode = .always
        textField.tintColor = .black
        return textField
    }()

    private let tabButtonView = TabButtonView(tabList: [.api, .favorite])

    private let tableView = {
        let tableView = UITableView()
        return tableView
    }()

    private let viewModel: UserListViewModelProtocol

    // MARK: - Initializer

    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = .white
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed
    }

    // MARK: - Helpers

    private func setUI() {
        view.addSubview(searchTextField)
        view.addSubview(tabButtonView)
        view.addSubview(tableView)

        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }

        tabButtonView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(tabButtonView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

final class TabButtonView: UIStackView {

    let selectedType: BehaviorRelay<TabButtonType?>
    private let tabList: [TabButtonType]

    private let disposeBag = DisposeBag()

    init(tabList: [TabButtonType]) {
        self.tabList = tabList
        self.selectedType = BehaviorRelay(value: tabList.first)
        super.init(frame: .zero)

        alignment = .fill
        distribution = .fillEqually
        addButtons()
        (arrangedSubviews.first as? UIButton)?.isSelected = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addButtons() {
        tabList.forEach { tabType in
            let button = TabButton(type: tabType)
            button.rx.tap.bind { [weak self] in
                self?.arrangedSubviews.forEach { view in
                    (view as? UIButton)?.isSelected = false
                }

                button.isSelected = true
                self?.selectedType.accept(tabType)
            }.disposed(by: disposeBag)
            addArrangedSubview(button)
        }
    }
}

final class TabButton: UIButton {

    private let type: TabButtonType

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .systemCyan
            } else {
                backgroundColor = .white
            }
        }
    }

    init(type: TabButtonType) {
        self.type = type
        super.init(frame: .zero)

        setTitle(type.rawValue, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
