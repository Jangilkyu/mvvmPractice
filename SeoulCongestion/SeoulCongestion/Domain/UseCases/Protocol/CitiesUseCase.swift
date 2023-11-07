//
//  CitiesUseCase.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/11/02.
//

import Foundation
import RxRelay
import RxSwift
import Moya

protocol CitiesUseCase {
    var provider: MoyaProvider<APIHandler> { get }
    var citiesList: PublishRelay<[Cities]> { get set }
    var citiesError: PublishRelay<Error> { get set}
    func requestCities()
}
