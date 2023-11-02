//
//  CitiesDTO.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/01/26.
//

import Foundation

struct Cities: Codable {
  var cities: [CitiesDTO]?
}

struct CitiesDTO: Codable {
    let areaNM: String?
    let livePpltnStts: LIVE_PPLTN_STTS?
    let avgRoadData: AVG_ROAD_DATA?
    let sbikeStts: [SBIKE_STTS]?
    let category: String?
    
    private enum CodingKeys: String, CodingKey {
        case areaNM = "AREA_NM"
        case livePpltnStts = "LIVE_PPLTN_STTS"
        case avgRoadData = "AVG_ROAD_DATA"
        case sbikeStts = "SBIKE_STTS"
        case category = "Category"
    }
}

struct LIVE_PPLTN_STTS: Codable {
    let areaCongestLvl: String?
    let areaCongestMSG: String?
    let areaPpltnMAX: String?
    let areaPpltnMIN: String?
    let femalePpltnRATE: String?
    let malePpltnRATE: String?
    let ppltnTIME: String?
    let resntPpltnRATE: String?
    
    private  enum CodingKeys: String, CodingKey {
        case areaCongestLvl = "AREA_CONGEST_LVL"
        case areaCongestMSG = "AREA_CONGEST_MSG"
        case areaPpltnMAX = "AREA_PPLTN_MAX"
        case areaPpltnMIN = "AREA_PPLTN_MIN"
        case femalePpltnRATE = "FEMALE_PPLTN_RATE"
        case malePpltnRATE = "MALE_PPLTN_RATE"
        case ppltnTIME = "PPLTN_TIME"
        case resntPpltnRATE = "RESNT_PPLTN_RATE"
    }
}

struct AVG_ROAD_DATA: Codable {
    let roadMSG: String?
    let roadTrafficIDX: String?
    let roadTrafficSPD: String?
    let roadTrafficTIME: String?
    
    private enum CodingKeys: String, CodingKey {
        case roadMSG = "ROAD_MSG"
        case roadTrafficIDX = "ROAD_TRAFFIC_IDX"
        case roadTrafficSPD = "ROAD_TRAFFIC_SPD"
        case roadTrafficTIME = "ROAD_TRFFIC_TIME"
        
    }
}

struct SBIKE_STTS: Codable {
    let parkingCnt: String?
    let rackCnt: String?
    let shared: String?
    let spotId: String?
    let spotName: String?
    let x: String?
    let y: String?
    let id: String?
    
    private enum CodingKeys: String, CodingKey {
        case parkingCnt = "SBIKE_PARKING_CNT"
        case rackCnt = "SBIKE_RACK_CNT"
        case shared = "SBIKE_SHARED"
        case spotId = "SBIKE_SPOT_ID"
        case spotName = "SBIKE_SPOT_NM"
        case x = "SBIKE_X"
        case y = "SBIKE_Y"
        case id = "_id"
    }
}
