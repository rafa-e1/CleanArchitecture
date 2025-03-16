//
//  TabButtonView.swift
//  CleanArchitecture
//
//  Created by RAFA on 3/16/25.
//

import RxCocoa
import RxSwift

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
