//
//  Date+Extensions.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public extension Date {
    
    static let emailDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    static let humanReadableDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.timeZone = .current
        dateFormatter.locale = Locale.current
        return dateFormatter
    }()
    
    public func toString() -> String {
        return Date.emailDateFormatter.string(from: self)
    }
    
    public func humanReadableString() -> String {
        return Date.humanReadableDateFormatter.string(from: self)
    }
    
    public func isDateToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
}
