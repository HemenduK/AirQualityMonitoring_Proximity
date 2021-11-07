//
//  AirQualityModel.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 06/11/21.
//

import UIKit

enum AirQualityRange {
    static let goodRange           = 0...50.00
    static let satisfactoryRange   = 50.01...100.00
    static let moderateRange       = 100.01...200.00
    static let poorRange           = 200.01...300.00
    static let veryPoorRange       = 300.01...400.00
    static let severeRange         = 400.01...500.00
}

enum AirQualityIndex: String, CaseIterable {
    case good           = "Good"
    case satisfactory   = "Satisfactory"
    case moderate       = "Moderate"
    case poor           = "Poor"
    case veryPoor       = "VeryPoor"
    case severe         = "Severe"
    case none           = "None"
    
    
    var color: UIColor {
        switch self {
        case .good:
            return UIColor(red: 72/255, green: 160/255, blue: 76/255, alpha: 1.0)
        case .satisfactory:
            return UIColor(red: 151/255, green: 195/255, blue: 83/255, alpha: 1.0)
        case .moderate:
            return UIColor(red: 254/255, green: 249/255, blue: 70/255, alpha: 1.0)
        case .poor:
            return UIColor(red: 241/255, green: 146/255, blue: 56/255, alpha: 1.0)
        case .veryPoor:
            return UIColor(red: 232/255, green: 52/255, blue: 48/255, alpha: 1.0)
        case .severe:
            return UIColor(red: 167/255, green: 37/255, blue: 35/255, alpha: 1.0)
        case .none:
            return .black
        }
    }
}

class AirQualityModel: NSObject {
    var city: String?
    var time: Date?
    var lastUpdated: String?
    var aqi : Double = 0.0
    var hasDegraded: Bool = false
    var category: AirQualityIndex {
        switch aqi {
        case AirQualityRange.goodRange:
            return .good
        case AirQualityRange.satisfactoryRange:
            return .satisfactory
        case AirQualityRange.moderateRange:
            return .moderate
        case AirQualityRange.poorRange:
            return .poor
        case AirQualityRange.veryPoorRange:
            return .veryPoor
        case AirQualityRange.severeRange:
            return .severe
        default:
            return .none
        }
    }
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let aqiVal : Double = dictionary["aqi"] as? Double{
            aqi = aqiVal.rounded(digits: 2)
        }
        
        if let strCity = dictionary["city"]{
            city = strCity as? String
        }
        
        time = Date()
        lastUpdated = Date().timeAgo
    }
}
