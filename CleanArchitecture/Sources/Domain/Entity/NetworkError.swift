//
//  NetworkError.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/25/25.
//

import Foundation

public enum NetworkError: Error {
    case urlError
    case invalidResponse
    case decodingError(String)
    case noData
    case serverError(Int)
    case requestFailed(String)

    public var description: String {
        switch self {
        case .urlError:                       "URL이 올바르지 않습니다."
        case .invalidResponse:                        "응답값이 유효하지 안습니다."
        case .decodingError(let description): "디코딩 에러 - \(description)"
        case .noData:                         "데이터가 없습니다."
        case .serverError(let statusCode):    "서버 에러 - \(statusCode)"
        case .requestFailed(let message):     "서버 요청 실패 - \(message)"
        }
    }
}
