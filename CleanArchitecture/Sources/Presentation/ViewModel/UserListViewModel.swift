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

final class UserListViewModel: UserListViewModelProtocol {

    // MARK: - Properties

    private let useCase: UserListUseCaseProtocol

    private let fetchUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let favoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    private let allFavoriteUserList = BehaviorRelay<[UserListItem]>(value: [])
    private var page: Int = 1

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
            guard let self = self, validateQuery(query: query) else {
                self?.getFavoriteUsers(query: "")
                return
            }

            page = 1
            fetchUser(query: query, page: page)
            getFavoriteUsers(query: query)
        }.disposed(by: disposeBag)

        input.saveFavorite
            .withLatestFrom(input.query, resultSelector: { users, query in
                return (users, query)
            })
            .bind { [weak self] user, query in
                self?.saveFavoriteUser(user: user, query: query)
            }.disposed(by: disposeBag)

        input.deleteFavorite
            .withLatestFrom(input.query, resultSelector: { ($0, $1) })
            .bind { [weak self] userID, query in
                self?.deleteFavoriteUser(userID: userID, query: query)
            }.disposed(by: disposeBag)

        input.fetchMore
            .withLatestFrom(input.query)
            .bind { [weak self] query in
                guard let self = self else { return }
                page += 1
                fetchUser(query: query, page: page)
            }.disposed(by: disposeBag)

        let cellData: Observable<[UserListCellData]> = Observable.combineLatest(
            input.tabButtonType,
            fetchUserList,
            favoriteUserList,
            allFavoriteUserList
        ).map { [weak self] tabButtonType, fetchUserList, favoriteUserList, allFavoriteUserList in
            var cellData: [UserListCellData] = []
            guard let self = self else { return cellData }

            switch tabButtonType {
            case .api:
                let tuple = useCase.checkFavoriteState(
                    fetchUsers: fetchUserList,
                    favoriteUsers: allFavoriteUserList
                )

                let userCellList = tuple.map { user, isFavorite in
                    UserListCellData.user(user: user, isFavorite: isFavorite)
                }

                return userCellList
            case .favorite:
                let dict = useCase.convertListToDictionary(favoriteUsers: favoriteUserList)
                let keys = dict.keys.sorted()
                keys.forEach { key in
                    cellData.append(.header(key))
                    if let users = dict[key] {
                        cellData += users.map { UserListCellData.user(user: $0, isFavorite: true) }
                    }
                }
            }

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
            let result = await useCase.fetchUser(query: urlAllowedQuery, page: page)
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

    private func saveFavoriteUser(user: UserListItem, query: String) {
        let result = useCase.saveFavoriteUser(user: user)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
        case .failure(let error):
            self.error.accept(error.description)
        }
    }

    private func deleteFavoriteUser(userID: Int, query: String) {
        let result = useCase.deleteFavoriteUser(userID: userID)
        switch result {
        case .success:
            getFavoriteUsers(query: query)
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
