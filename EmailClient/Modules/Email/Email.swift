//
//  EmailModule.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct Email {
    
    public static func createService(withEnvironment environment: Environment) -> EmailStateService {
        // Using switch in case we pass different params for different environments later...
        switch environment {
        case .production: return EmailStateService(withEnvironment: environment)
        case .debug: return EmailStateService(withEnvironment: environment)
        case .testing: return EmailStateService(withEnvironment: environment)
        }
    }
    
}
