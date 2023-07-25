//
//  Date.swift
//  Footi
//
//  Created by Jon Schlandt on 3/6/23.
//

import Foundation

extension Date {
    
    // MARK: Public methods
    
    public static func getDateFromISO8601(using isoString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: isoString)
        
        return date
    }

    public static func getCurrentDateString(as format: String) -> String {
        return getDateString(from: Date(), as: format)
    }
    
    public static func getDateStringYesterday(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: noonToday)!
        
        return dateFormatter.string(from: yesterday)
    }
    
    public static func getDateStringTomorrow(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: noonToday)!
        
        return dateFormatter.string(from: tomorrow)
    }
    
    public static func getDateString(from date: Date, as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
