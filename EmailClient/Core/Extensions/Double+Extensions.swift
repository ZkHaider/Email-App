//
//  Double+Extensions.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public extension Double {
    
    public func getDateFromUnixStamp() -> Date {
        return Date(timeIntervalSince1970: self)
    }
    
    public func getDateStringFromUnixTime(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
    
}

extension TimeInterval {
    
    func stringFromTimeInterval() -> String {
        
        let hours = (Int(self) / 3600)
        let minutes = Int(self / 60) - Int(hours * 60)
        let seconds = Int(self) - (Int(self / 60) * 60)
        
        return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
    }
    
}
