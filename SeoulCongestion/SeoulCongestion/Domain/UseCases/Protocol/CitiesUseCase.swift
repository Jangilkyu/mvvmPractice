//
//  CitiesUseCase.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/11/02.
//

import Foundation
import RxRelay
import RxSwift


protocol CitiesUseCase {
    var citiesList: PublishRelay<[CitiesDTO]> { get set }
    func requestCities()
}
