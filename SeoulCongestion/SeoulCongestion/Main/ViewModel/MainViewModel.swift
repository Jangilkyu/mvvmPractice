//
//  MainViewModel.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/10/11.
//

import Foundation

class MainViewModel  {
  var seoulCities: SeoulCities!
  var api: RestProcessor!
  var resHandler: ResHandler!
  
  var viewAll: [City] = [] // 전체보기
  var culturalheritage: [City] = [] // 고궁 · 문화유산
  var park: [City] = [] // 공원
  var tourismSpecialZone: [City] = [] // 관광특구
  var centralBusinessDistrict: [City] = [] // 발달상권
  var denselyPopulatedArea: [City] = [] // 인구밀집지역

  private func getCitiesAPIInfo() {
    api.makeRequest(
      toURL: EndPoint.seoulCitiesData.url,
      withHttpMethod: .get,
      usage: .seoulCitiesData
    )
  }
  
  
  private func getCitiesSearchAPI() {
    guard let searchCities = self.citySearchTextField.textField.text?.trimmingCharacters(in: .whitespaces) else { return }
    if searchCities.count == 0{
      DispatchQueue.main.async {
        let alert = UIAlertController(title: nil, message: "지역을 입력 해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okAction)
        self.present(alert, animated: false, completion: nil)
      }
    } else {
      self.citySearchTextField.buttonState = .loading
      self.citySearchTextField.textField.isEnabled = false
      api.urlQueryParameters.add(
        value: searchCities,
        forKey: "searchId"
      )
      
      api.makeRequest(
        toURL: EndPoint.search.url,
        withHttpMethod: .get,
        usage: .search
      )
    }
  }
  
  
  private func categorizeCities() {
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
}
