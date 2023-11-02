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

class CitiesUseCaseImpl: CitiesUseCase {
    
    var citiesList = PublishRelay<[CitiesDTO]>()
    
    func requestCities() {
        print("requestCities")
    }
}
