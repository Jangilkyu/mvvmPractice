//
//  MainViewModel.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/10/11.
//

import Foundation

class MainViewModel  {
    var seoulCities: SeoulCities!
    var restProcessor: RestProcessor!
    var resHandler: ResHandler!
    
    /// 전체보기
    var viewAll: [City] = []
    /// 고궁 · 문화유산
    var culturalheritage: [City] = []
    /// 공원
    var park: [City] = []
    /// 관광특구
    var tourismSpecialZone: [City] = []
    /// 발달상권
    var centralBusinessDistrict: [City] = []
    /// 인구밀집지역
    var denselyPopulatedArea: [City] = []
    
    func getCitiesAPIInfo() {
        restProcessor.makeRequest(
            toURL: EndPoint.seoulCitiesData.url,
            withHttpMethod: .get,
            usage: .seoulCitiesData
        )
    }
    
    init(restProcessor: RestProcessor) {
        self.restProcessor = restProcessor
    }
    
    /// 도시 검색
    func getCitiesSearchAPI(_ textField: String) {
        let searchCities = textField
        restProcessor.urlQueryParameters.add(
            value: searchCities,
            forKey: "searchId"
        )
        
        restProcessor.makeRequest(
            toURL: EndPoint.search.url,
            withHttpMethod: .get,
            usage: .search
        )
    }
    
    /// 도시 분류
    func categorizeCities() {
        viewAll = self.seoulCities.getCity()!
        for data in self.seoulCities.getCity()! {
            if data.Category == "고궁·문화유산" {
                culturalheritage.append(data)
            } else if data.Category == "공원" {
                park.append(data)
            } else if data.Category == "관광특구" {
                tourismSpecialZone.append(data)
            } else if data.Category == "발달상권" {
                centralBusinessDistrict.append(data)
            } else if data.Category == "인구밀집지역" {
                denselyPopulatedArea.append(data)
            }
        }
    }
    
    ///
    func sortCitiesByAlphabet(
        _ cities: [City]) -> [City] {
            return cities.sorted { city1, city2 in
                if let city1 = city1.areaNM, let city2 = city2.areaNM {
                    return city1.localizedCompare(city2) == .orderedAscending
                }
                return false
            }
        }
}


