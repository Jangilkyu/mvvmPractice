//
//  SeoulCities.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/02/07.
//

import Foundation

class SeoulCities {
  var cities: [Cities]
  
  init(_ cities: [Cities]) {
    self.cities = cities
  }
  
  func getCity() -> [CitiesDTO]? {
    return cities[0].cities
  }
  
  func setCity(city: [CitiesDTO]?) {
    self.cities[0].cities = city
  }
  
  func getNumberOfCities() -> Int {
    if cities.count > 0 {
      let numberOfCities = cities[0].cities!.count
      return numberOfCities
    }
    return 0
  }
  
  func getOneCenter(at indexPath: IndexPath) -> CitiesDTO? {
      guard let cities = self.getCity(), indexPath.row < cities.count else {
          print("Error: Invalid index path or empty city list")
          return nil
      }
      let city = cities[indexPath.row]
      return city
  }
  
}
