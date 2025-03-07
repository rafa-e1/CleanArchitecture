//
//  UserListViewModel.swift
//  CleanArchitecture
//
//  Created by RAFA on 3/7/25.
//

import RxCocoa
import RxSwift

protocol UserListViewModelProtocol {

}

final class UserListItemViewModel: UserListViewModelProtocol {

    // MARK: - Properties

    private let useCase: UserListUseCaseProtocol

    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: [])

    private let error = PublishRelay<String>()
    private let disposeBag = DisposeBag()

    // MARK: - Initializer

    init(useCase: UserListUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Input

    struct Input {
        let tabButtonType: Observable<TabButtonType>
        let query: Observable<String>
        let saveFavorite: Observable<UserListItem>
        let deleteFavorite: Observable<Int>
        let fetchMore: Observable<Void>
    }

    // MARK: - Output

    struct Output {
        let cellData: Observable<[UserListCellData]>
        let error: Observable<String>
    }

    // MARK: - Helpers

    func transform(input: Input) -> Output {
        input.query.bind { [weak self] query in
            guard let isValidate = self?.validateQuery(query: query), isValidate else {
                self?.getFavoriteUsers(query: query)
                return
            }

            self?.fetchUser(query: query, page: 0)
            self?.getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)

        input.saveFavorite.bind { user in
            <#code#>
        }.disposed(by: disposeBag)

        input.deleteFavorite.bind { userID in
            <#code#>
        }.disposed(by: disposeBag)

        input.fetchMore.bind {
            <#code#>
        }.disposed(by: disposeBag)

        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(
            input.tabButtonType,
            fetchUserList,
            favoriteUserList
        ).map { tabButtonType, fetchUserList, favoriteUserList in
            let cellData: [UserListCellData] = []
            return cellData
        }

        return Output(cellData: cellData, error: error.asObservable())
    }

    private func fetchUser(query: String, page: Int) {
        guard let urlAllowedQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) else {
            return
        }

        Task {
            let result = await useCase.fetchUser(query: query, page: page)
            switch result {
            case .success(let users):
                if page == 0 {
                    fetchUserList.accept(users.items)
                } else {
                    fetchUserList.accept(fetchUserList.value + users.items)
                }
            case .failure(let error):
                self.error.accept(error.description)
            }
        }
    }

    private func getFavoriteUsers(query: String) {
        let result = useCase.getFavoriteUsers()
        switch result {
        case .success(let users):
            if query.isEmpty {
                favoriteUserList.accept(users)
            } else {
                let filteredUsers = users.filter { user in
                    user.login.contains(query)
                }

                favoriteUserList.accept(filteredUsers)
            }

            allFavoriteUserList.accept(users)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }

    private func validateQuery(query: String) -> Bool {
        if query.isEmpty {
            return false
        } else {
            return true
        }
    }
}

enum TabButtonType {
    case api
    case favorite
}

enum UserListCellData {
    case user(user: UserListItem, isFavorite: Bool)
    case header(String)
}
