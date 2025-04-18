//
//  MockUserUseCase.swift
//  CleanArchitectureTests
//
//  Created by RAFA on 4/18/25.
//

import Foundation
@testable import CleanArchitecture

class MockUserUseCase: UserListUseCaseProtocol {

    var fetchUserResult: Result<UserListResult, NetworkError>?
    var favoriteUserResult: Result<[UserListItem], CoreDataError>?

    func fetchUser(
        query: String,
        page: Int
    ) async -> Result<CleanArchitecture.UserListResult, CleanArchitecture.NetworkError> {
        fetchUserResult ?? .failure(.noData)
    }
    
    func getFavoriteUsers() -> Result<
        [CleanArchitecture.UserListItem],
        CleanArchitecture.CoreDataError
    > {
        favoriteUserResult ?? .failure(.entityNotFound(""))
    }
    
    func saveFavoriteUser(
        user: CleanArchitecture.UserListItem
    ) -> Result<Bool, CleanArchitecture.CoreDataError> {
        .success(true)
    }
    
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CleanArchitecture.CoreDataError> {
        .success(true)
    }
    
    func checkFavoriteState(
        fetchUsers: [UserListItem],
        favoriteUsers: [UserListItem]
    ) -> [(user: UserListItem, isFavorite: Bool)] {
        let favoriteSet = Set(favoriteUsers)
        return fetchUsers.map { user in
            if favoriteSet.contains(user) {
                return (user: user, isFavorite: true)
            } else {
                return (user: user, isFavorite: false)
            }
        }
    }

    func convertListToDictionary(favoriteUsers: [UserListItem]) -> [String : [UserListItem]] {
        favoriteUsers.reduce(into: [String: [UserListItem]]()) { dict, user in
            if let firstString = user.login.first {
                let key = String(firstString).uppercased()
                dict[key, default: []].append(user)
            }
        }
    }
}
