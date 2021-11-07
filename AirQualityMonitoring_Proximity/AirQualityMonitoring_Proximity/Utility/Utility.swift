//
//  Utility.swift
//  AirQualityMonitoring_Proximity
//
//  Created by Hemendu.Kathiriya on 06/11/21.
//

import UIKit
import Charts

class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "dd MMM HH:mm"
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: value))
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        return date.timeString
    }
}

extension Date {
    var timeAgo: String {
        let interval = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: self, to: Date())
        if let day = interval.day, day > 0 {
            return day == 1 ? "\(day) day" : "\(day) days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour) hour" : self.timeString
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "A minute ago" : "\(minute) minutes"
        } else if let second = interval.second, second > 0 {
            return second < 5 ? "A few seconds ago" : "\(second) seconds"
        } else {
            return "Just now"
        }
    }
    
    var timeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
}

extension Double {
    func rounded(digits: Int) -> Double {
        let multiplier = pow(10.0, Double(digits))
        return (self * multiplier).rounded() / multiplier
    }
}
