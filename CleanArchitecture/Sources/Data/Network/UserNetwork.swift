//
//  UserNetwork.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/26/25.
//

import Foundation

protocol UserNetworkProtocol {
    func fetchUsers(query: String, page: Int) async -> Result<UserListResult, NetworkError>
}

final class UserNetwork: UserNetworkProtocol {

    private let manager: NetworkManagerProtocol

    init(manager: NetworkManagerProtocol) {
        self.manager = manager
    }

    func fetchUsers(
        query: String,
        page: Int
    ) async -> Result<UserListResult, NetworkError> {
        let url = "https://api.github.com/search/users?q=\(query)&page=\(page)"
        return await manager.fetchData(url: url, method: .get, parameters: nil)
    }
}
