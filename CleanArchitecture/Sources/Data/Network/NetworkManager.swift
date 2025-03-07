//
//  NetworkManager.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/26/25.
//

import Alamofire

protocol NetworkManagerProtocol {
    func fetchData<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?
    ) async -> Result<T, NetworkError>
}

class NetworkManager: NetworkManagerProtocol {

    private let session: SessionProtocol

    private let tokenHeader: HTTPHeaders = {
        let tokenHeader = HTTPHeader(
            name: "Authorization",
            value: "Bearer \(NetworkEnvironment.apiKey)"
        )

        return HTTPHeaders([tokenHeader])
    }()

    init(session: SessionProtocol) {
        self.session = session
    }

    func fetchData<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters?
    ) async -> Result<T, NetworkError> {
        guard let url = URL(string: url) else { return .failure(.urlError) }

        let result = await session.request(
            url,
            method: method,
            parameters: parameters,
            headers: tokenHeader
        ).serializingData().response

        if let error = result.error {
            return .failure(.requestFailed(error.localizedDescription))
        }

        guard let data = result.data else { return .failure(.noData) }
        guard let response = result.response else { return .failure(.invalidResponse) }

        if 200 ..< 400 ~= response.statusCode {
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                return .success(data)
            } catch {
                return .failure(.decodingError(error.localizedDescription))
            }
        } else {
            return .failure(.serverError(response.statusCode))
        }
    }
}
