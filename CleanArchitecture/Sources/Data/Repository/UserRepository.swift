//
//  UserRepository.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/27/25.
//

import Foundation

struct UserRepository: UserRepositoryProtocol {

    private let coreData: UserCoreDataProtocol, network: UserNetworkProtocol

    init(coreData: UserCoreDataProtocol, network: UserNetworkProtocol) {
        self.coreData = coreData
        self.network = network
    }

    func fetchUser(query: String, page: Int) async -> Result<UserListResult, NetworkError> {
        return await network.fetchUsers(query: query, page: page)
    }
    
    func getFavoriteUsers() -> Result<[UserListItem], CoreDataError> {
        return coreData.getFavoriteUsers()
    }
    
    func saveFavoriteUser(user: UserListItem) -> Result<Bool, CoreDataError> {
        return coreData.saveFavoriteUser(user: user)
    }
    
    func deleteFavoriteUser(userID: Int) -> Result<Bool, CoreDataError> {
        return coreData.deleteFavoriteUser(userID: userID)
    }
}
