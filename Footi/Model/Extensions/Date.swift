//
//  Date.swift
//  Footi
//
//  Created by Jon Schlandt on 3/6/23.
//

import Foundation

extension Date {

    static func getCurrentDate(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: Date())
    }
    
    static func getDateYesterday(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: noonToday)!
        
        return dateFormatter.string(from: yesterday)
    }
    
    static func getDateTomorrow(as format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let noonToday = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: noonToday)!
        
        return dateFormatter.string(from: tomorrow)
    }
}
