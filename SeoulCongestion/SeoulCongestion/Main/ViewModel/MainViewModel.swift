//
//  MainViewModel.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/10/15.
//

import Foundation
import RxSwift
import RxRelay

class MainViewModel {
    var seoulCities: SeoulCities?
    var resHandler: ResHandler?
    var restProcessor: RestProcessor
    
    var disposeBag = DisposeBag()
    
    public var citySearchTextFieldObserver = PublishRelay<String>()
    public var citySearchTextFieldOutPutObserver = PublishRelay<String>()
    
    public var cityTabListObserver = PublishRelay<CityTab>()
    public var dropDownObserver = PublishRelay<String>()
    public var sortCitiesByAlphabetOutputObserver = PublishRelay<[City]>()
    public var didSelectTabObserver = PublishRelay<CityTab>()
    public var didSelectTabOutPutObserver = PublishRelay<[City]>()
    
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
    
    init(restProcessor: RestProcessor) {
        self.restProcessor = restProcessor
        bind()
    }
    
    func bind() {
        citySearchTextFieldObserver.subscribe { text in
            self.citySearchTextFieldOutPutObserver.accept(text)
        }
        .disposed(by: disposeBag)
        
        dropDownObserver.subscribe { item in
            self.updateCollectionViewWithSelectedString(item,self.seoulCities?.getCity())
        }
        .disposed(by: disposeBag)
        
        
        didSelectTabObserver.subscribe { tab in
            let result = self.didSelectTab(tab)
            self.didSelectTabOutPutObserver.accept(result)
        }
        .disposed(by: disposeBag)
    }
    
    func getCitiesAPIInfo() {
        restProcessor.makeRequest(
        toURL: EndPoint.seoulCitiesData.url,
        withHttpMethod: .get,
        usage: .seoulCitiesData
      )
    }
    
    /// 도시 검색
    func getCitiesSearchAPI(_ searchCity: String) {
        restProcessor.urlQueryParameters.add(
          value: searchCity,
          forKey: "searchId"
        )
        
        restProcessor.makeRequest(
          toURL: EndPoint.search.url,
          withHttpMethod: .get,
          usage: .search
        )
    }
    
    func categorizeCities() {
        guard let seoulCities = seoulCities?.getCity() else { return }
        viewAll = seoulCities
        for data in seoulCities {
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
    
    func updateCollectionViewWithSelectedString(
      _ selectedString: String,
      _ cities: [City]? = nil
    ) {
        guard let cities = cities else { return }
        let citiesToUse: [City] = cities

      if selectedString == "가나다 순" {
          let alphabeticalSorted = self.sortCitiesByAlphabet(citiesToUse)
          sortCitiesByAlphabetOutputObserver.accept(alphabeticalSorted)
      } else if selectedString == "인구 혼잡도 순" {
        print("인구 혼잡도 순")
      }
    }
    
    func sortCitiesByAlphabet(
      _ cities: [City]) -> [City] {
      return cities.sorted { city1, city2 in
        if let city1 = city1.areaNM, let city2 = city2.areaNM {
          return city1.localizedCompare(city2) == .orderedAscending
        }
        return false
      }
    }
    
    func didSelectTab(_ tab: CityTab) -> [City] {
        switch tab {
        case .viewAll:
            return self.viewAll
        case .culturalheritage:
            return self.culturalheritage
        case .park:
            return self.park
        case .specialTouristZone:
            return self.tourismSpecialZone
        case .centralBusinessDistrict:
            return self.centralBusinessDistrict
        case .denselyPopulatedArea:
            return self.denselyPopulatedArea
        }
    }
}
