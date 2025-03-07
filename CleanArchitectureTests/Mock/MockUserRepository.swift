//
//  MockUserRepository.swift
//  CleanArchitectureTests
//
//  Created by RAFA on 3/7/25.
//

@testable import CleanArchitecture

struct MockUserRepository: UserRepositoryProtocol {

    func fetchUser(
        query: String,
        page: Int
    ) async -> Result<CleanArchitecture.UserListResult, CleanArchitecture.NetworkError> {
        .failure(.noData)
    }
    
    func getFavoriteUsers() -> Result<
        [CleanArchitecture.UserListItem],
        CleanArchitecture.CoreDataError
    > {
        .failure(.entityNotFound(""))
    }
    
    func saveFavoriteUser(
        user: CleanArchitecture.UserListItem
    ) -> Result<Bool, CleanArchitecture.CoreDataError> {
        .failure(.entityNotFound(""))
    }
    
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CleanArchitecture.CoreDataError> {
        .failure(.entityNotFound(""))
    }
}
