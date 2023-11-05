//
//  APIHandler.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/11/02.
//

import Foundation
import Moya

enum APIHandler {
    case seoulCitiesData
}

extension APIHandler: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://zeroganseoul-server.onrender.com/api/v1") else {
            fatalError("Invalid base URL")
        }
        return url
    }
    var path: String {
        switch self {
        case .seoulCitiesData:
            return "/seoulCitiesData"
        }
    }
    var method: Moya.Method {
        switch self {
        case .seoulCitiesData:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .seoulCitiesData:
            return .requestPlain
        }
    }
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String : String]? {
        return [:]
    }
}


class CitiesProvider {
    static let shared = CitiesProvider()

    private let provider: MoyaProvider<APIHandler>
    
    private init() {
        provider = MoyaProvider<APIHandler>()
    }

    func getMoyaProvider() -> MoyaProvider<APIHandler> {
        return provider
    }
}

