//
//  CitiesViewModel.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/10/15.
//

import Foundation
import RxSwift
import RxRelay

class CitiesViewModel {
    var seoulCities: SeoulCities?
    
    var disposeBag = DisposeBag()
    
    public var citySearchTextFieldObserver = PublishRelay<String>()
    public var citySearchTextFieldOutPutObserver = PublishRelay<String>()
    public var automaticSearch = BehaviorRelay<String>(value: "")
    public var automaticSearchObserver = PublishRelay<[CitiesDTO]>()
    public var searchResultList = PublishRelay<[CitiesDTO]>()
    
    public var cityTabListObserver = PublishRelay<CityTab>()
    public var dropDownObserver = PublishRelay<String>()
    public var sortCitiesByAlphabetOutputObserver = PublishRelay<[CitiesDTO]>()
    public var didSelectTabObserver = PublishRelay<CityTab>()
    public var didSelectTabOutPutObserver = PublishRelay<[CitiesDTO]>()
    public var citiesRelay = BehaviorRelay<[CitySectionModel]>(value: [])
    public var searchButtonObserver = PublishRelay<String>()

    /// 전체보기
    var viewAll: [CitiesDTO] = []
    /// 고궁 · 문화유산
    var culturalheritage: [CitiesDTO] = []
    /// 공원
    var park: [CitiesDTO] = []
    /// 관광특구
    var tourismSpecialZone: [CitiesDTO] = []
    /// 발달상권
    var centralBusinessDistrict: [CitiesDTO] = []
    /// 인구밀집지역
    var denselyPopulatedArea: [CitiesDTO] = []
    
    init() {
        bind()
    }
    
    func bind() {
        
        searchButtonObserver.subscribe { text in
            guard let cities = self.seoulCities?.getCity() else { return }
            
            let filteredCities = cities.filter { city in
                return city.areaNM!.hasPrefix(text)
            }
            
            
            self.searchResultList.accept(filteredCities)
        }
        .disposed(by: disposeBag)
        
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
        
        automaticSearch.subscribe { text in
            guard let cities = self.seoulCities?.getCity() else { return }
            
            let filteredCities = cities.filter { city in
                return city.areaNM!.hasPrefix(text)
            }
            
            self.automaticSearchObserver.accept(filteredCities)
        }
        .disposed(by: disposeBag)
    }
        
    func categorizeCities() {
        guard let seoulCities = seoulCities?.getCity() else { return }
        viewAll = seoulCities
        for data in seoulCities {
            if data.category == "고궁·문화유산" {
                culturalheritage.append(data)
            } else if data.category == "공원" {
                park.append(data)
            } else if data.category == "관광특구" {
                tourismSpecialZone.append(data)
            } else if data.category == "발달상권" {
                centralBusinessDistrict.append(data)
            } else if data.category == "인구밀집지역" {
                denselyPopulatedArea.append(data)
            }
        }
    }
    
    func updateCollectionViewWithSelectedString(
      _ selectedString: String,
      _ cities: [CitiesDTO]? = nil
    ) {
        guard let cities = cities else { return }
        let citiesToUse: [CitiesDTO] = cities

      if selectedString == "가나다 순" {
          let alphabeticalSorted = self.sortCitiesByAlphabet(citiesToUse)
          sortCitiesByAlphabetOutputObserver.accept(alphabeticalSorted)
      } else if selectedString == "인구 혼잡도 순" {
        print("인구 혼잡도 순")
      }
    }
    
    func sortCitiesByAlphabet(
      _ cities: [CitiesDTO]) -> [CitiesDTO] {
      return cities.sorted { city1, city2 in
        if let city1 = city1.areaNM, let city2 = city2.areaNM {
          return city1.localizedCompare(city2) == .orderedAscending
        }
        return false
      }
    }
    
    func didSelectTab(_ tab: CityTab) -> [CitiesDTO] {
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
