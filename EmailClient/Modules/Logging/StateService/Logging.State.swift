//
//  Logging.State.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct LoggingState {
    public let loggingText: String
    public let isLogging: Bool
}

extension LoggingState: Equatable {
    
    public static func ==(lhs: LoggingState, rhs: LoggingState) -> Bool {
        if lhs.loggingText != rhs.loggingText {
            return false
        }
        if lhs.isLogging != rhs.isLogging {
            return false
        }
        return true
    }
    
}
