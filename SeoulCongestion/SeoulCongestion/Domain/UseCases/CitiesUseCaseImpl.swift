//
//  CitiesUseCaseImpl.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/11/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import Moya

class CitiesUseCaseImpl: CitiesUseCase {
    let provider: MoyaProvider<APIHandler>
    var citiesList = PublishRelay<[Cities]>()
    
    init(provider: MoyaProvider<APIHandler>) {
        self.provider = provider
    }
    
    func requestCities() {
        provider.request(.seoulCitiesData) { result in
            switch result {
            case .success(let res):
                guard let cities = try? JSONDecoder().decode([Cities].self, from: res.data) else { return }
                self.citiesList.accept(cities)
            case .failure(let error):
                print(error)
//                completion(.failure(error))
            }
        }
    }
}
