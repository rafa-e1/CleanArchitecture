//
//  NetworkEnvironment.swift
//  CleanArchitecture
//
//  Created by RAFA on 2/26/25.
//

import Foundation

struct NetworkEnvironment {

    static var apiKey: String {
        guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
              !apiKey.isEmpty
        else {
            fatalError("API KEY를 찾을 수 없습니다.")
        }

        return apiKey
    }
}
