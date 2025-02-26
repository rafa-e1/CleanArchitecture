//
//  UserSession.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/26/25.
//

import Alamofire

protocol SessionProtocol {
    func request(
        _ convertible: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?
    ) -> DataRequest
}

class UserSession {

    private var session: Session

    init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = Session(configuration: config)
    }

    func request(
        _ convertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil
    ) -> DataRequest {
        return session.request(
            convertible,
            method: method,
            parameters: parameters,
            headers: headers
        )
    }
}
