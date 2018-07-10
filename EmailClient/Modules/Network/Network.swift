//
//  Network.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct Network {
    
    public static func createService(withEnvironment environment: Environment) -> NetworkStateService {
            switch environment {
            case .production: return NetworkStateService(withEnvironment: environment)
            case .debug: return NetworkStateService(withEnvironment: environment)
            case .testing: return NetworkStateService(withEnvironment: environment)
            }
    }
    
}
