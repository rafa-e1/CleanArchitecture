//
//  UserUseCaseTests.swift
//  CleanArchitectureTests
//
//  Created by RAFA on 3/7/25.
//

import XCTest
@testable import CleanArchitecture

final class UserUseCaseTests: XCTestCase {

    var repository: UserRepositoryProtocol!
    var useCase: UserListUseCaseProtocol!

    override func setUp() {
        super.setUp()

        repository = MockUserRepository()
        useCase = UserListUseCase(repository: repository)
    }

    func testCheckFavoriteState() {
        let favoriteUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 2, login: "user2", imageURL: "")
        ]

        let fetchUsers = [
            UserListItem(id: 1, login: "user1", imageURL: ""),
            UserListItem(id: 3, login: "user3", imageURL: "")
        ]

        let result = useCase.checkFavoriteState(
            fetchUsers: fetchUsers,
            favoriteUsers: favoriteUsers
        )

        XCTAssertEqual(result[0].isFavorite, true)
        XCTAssertEqual(result[1].isFavorite, false)
    }

    func testConvertListToDictionary() {
        let users = [
            UserListItem(id: 1, login: "Alice", imageURL: ""),
            UserListItem(id: 2, login: "Bob", imageURL: ""),
            UserListItem(id: 3, login: "Charlie", imageURL: ""),
            UserListItem(id: 4, login: "ash", imageURL: "")
        ]

        let result = useCase.convertListToDictionary(favoriteUsers: users)

        XCTAssertEqual(result.keys.count, 3)
        XCTAssertEqual(result["A"]?.count, 2)
        XCTAssertEqual(result["B"]?.count, 1)
        XCTAssertEqual(result["C"]?.count, 1)
    }

    override func tearDown() {
        repository = nil
        useCase = nil
        super.tearDown()
    }
}
