//
//  AppContext.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct AppContext {
    
    public static var serviceCenter: StateServiceCenter {
        return shared.center
    }
    
    internal static var _shared: AppContext?  = nil
    public static var shared: AppContext {
        guard
            let shared = _shared
            else {
                let context = AppContext()
                _shared = context
                return context
        }
        return shared
    }
    
    let center: StateServiceCenter
    
    public var serviceCenter: StateServiceCenter {
        return center
    }
    
    fileprivate init() {
        self.center = StateServiceCenter()
    }
    
    public func reset() {
        StateServiceCenter.defaultCenter.context.unregisterAllServices()
        AppContext._shared = AppContext()
    }
    
    public static func reset() {
        StateServiceCenter.defaultCenter.unregisterAllServices()
        AppContext._shared = AppContext()
    }
    
}

extension StateServiceCenter {
    public static var defaultCenter: StateServiceCenter {
        return AppContext.serviceCenter
    }
}
