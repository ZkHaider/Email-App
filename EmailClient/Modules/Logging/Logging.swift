//
//  Logging.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct Logging {
    
    public static func createService(withEnvironment environment: Environment) -> LoggingStateService {
        switch environment {
        case .production: return LoggingStateService(withEnvironment: environment)
        case .debug: return LoggingStateService(withEnvironment: environment)
        case .testing: return LoggingStateService(withEnvironment: environment)
        }
    }
    
}
