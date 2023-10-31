//
//  CitySectionModel.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/10/31.
//

import Foundation
import RxDataSources

struct CitySectionModel {
    var header: String // 섹션 헤더 타이틀
    var items: [City] // 해당 섹션에 속하는 CityItem 배열
}

extension CitySectionModel: SectionModelType {
    typealias Item = City

    // 섹션 헤더 타이틀을 반환하는 메서드
    init(original: CitySectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

