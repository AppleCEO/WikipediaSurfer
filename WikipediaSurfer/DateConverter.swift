//
//  DateConverter.swift
//  WikipediaSurfer
//
//  Created by joon-ho kil on 2019/10/09.
//  Copyright © 2019 길준호. All rights reserved.
//

import Foundation

struct DateConverter {
    static func stringToDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        if let date = dateFormatter.date(from: string) {
            return date
        }
        
        return Date.init()
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        
        return dateFormatter.string(from: date)
    }
}
