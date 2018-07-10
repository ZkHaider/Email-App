//
//  ServiceSetup.swift
//  EmailClient
//
//  Created by Haider Khan on 7/9/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

extension StateServiceCenter {
    
    public struct Events {
        public struct BootstrapCompletedEvent: IdentifiableEvent {}
    }
    
    func setConfiguration() {
        switch Environment.currentEnvironment() {
        case .production:
            let setup: ServiceSetup = .production
            setup.bootstrap(serviceCenter: self)
        case .debug:
            let setup: ServiceSetup = .debug
            setup.bootstrap(serviceCenter: self)
        case .testing:
            let setup: ServiceSetup = .testing
            setup.bootstrap(serviceCenter: self)
        }
    }
    
}

public enum ServiceSetup: StateConfiguration {
    
    case production
    case debug
    case testing
    
    public func bootstrap(serviceCenter: StateServiceCenter) {
        switch Environment.currentEnvironment() {
        case .production:
            
            let intitialServices: [BaseService] = [
                Logging.createService(withEnvironment: Environment.currentEnvironment()),
                Network.createService(withEnvironment: Environment.currentEnvironment()),
                Email.createService(withEnvironment: Environment.currentEnvironment())
            ]
            serviceCenter.register(services: intitialServices) {
                
            }
            
        case .debug:
            
            let intitialServices: [BaseService] = [
                Logging.createService(withEnvironment: Environment.currentEnvironment()),
                Network.createService(withEnvironment: Environment.currentEnvironment()),
                Email.createService(withEnvironment: Environment.currentEnvironment())
            ]
            serviceCenter.register(services: intitialServices) {
                
            }
            
        case .testing:
            
            let intitialServices: [BaseService] = [
                Logging.createService(withEnvironment: Environment.currentEnvironment()),
                Network.createService(withEnvironment: Environment.currentEnvironment()),
                Email.createService(withEnvironment: Environment.currentEnvironment())
            ]
            serviceCenter.register(services: intitialServices) {
                
                // Once setup is done let all services know we are done with setup
                serviceCenter.allServices().forEach({ service in
                    service.dispatch(StateServiceCenter.Events.BootstrapCompletedEvent())
                })
            }
        }
    }
    
}
