//
//  UserListViewController.swift
//  CleanArchitecture
//
//  Created by RAFA on 3/7/25.
//

import UIKit

class UserListViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: UserListViewModelProtocol

    // MARK: - Initializer

    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemRed
    }
}
