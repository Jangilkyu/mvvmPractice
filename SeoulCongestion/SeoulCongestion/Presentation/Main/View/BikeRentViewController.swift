//
//  BikeRentViewController.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/11/01.
//

import UIKit

class BikeRentViewController: UIViewController {
    let useCase: BikeRentUseCase
    let viewModel: BikeRentViewModel
    
    init(useCase: BikeRentUseCase, viewModel: BikeRentViewModel) {
        self.useCase = useCase
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        useCase.requestBikeList()
    }
}

protocol BikeRentUseCase {
    func requestBikeList() -> [Int]
    func rentBike(bikeNumber: Int) -> [Int]
}

/// API 요청
class BikeRentUseCaseImpl : BikeRentUseCase{
    func requestBikeList() -> [Int] {
        return [1,2,3]
    }
    
    func rentBike(bikeNumber: Int) -> [Int] {
        return [1,2,3]
    }
}


protocol BikeRentViewModel {
    
}

class BikeRentViewModelImpl : BikeRentViewModel {
    func modifyBikeList(list: [Int]) -> [String: Int] {
        var dict: [String: Int] = [:]
        for i in list.indices {
            dict["\(i)"] = list[i]
        }
        return dict
    }
}
