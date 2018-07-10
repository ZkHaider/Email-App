//
//  StateContext.swift
//  SimpleEvent
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 Koin. All rights reserved.
//

import Foundation

public final class StateContext: NSObject {
    
    // MARK: - Attributes
    
    internal var activeServices: [ServiceIdentifier: Service] = [:]
    
    // MARK: - Init
    
    public override init() {
        super.init()
    }
    
    // MARK: - Registration Functions
    
    internal func register<T: Service>(services: [T]) {
        for service in services {
            let identifier = service.identifier
            activeServices[identifier] = service
        }
    }
    
    internal func register<T: Service>(service: T) {
        let identifier = service.identifier
        activeServices[identifier] = service
    }
    
    internal func service<T>(for identifier: ServiceIdentifier) -> T? where T: BaseService {
        return activeServices[identifier] as? T ?? nil
    }
    
    internal func anyService(for identifier: ServiceIdentifier) -> Service? {
        return activeServices[identifier]
    }
    
    internal func retrieveService<T>() -> T where T: BaseService {
        let identifier = T.defaultIdentifier
        guard let service: T = self.service(for: identifier) else {
            let service = T()
            register(service: service)
            return service
        }
        return service
    }
    
    internal func allServices() -> [Service] {
        return activeServices.values.compactMap({$0})
    }
    
    internal func unregisterService(with identifier: ServiceIdentifier) {
        activeServices[identifier] = nil
    }
    
    internal func unregisterAllServices() {
        activeServices.removeAll()
    }

}

extension StateServiceCenter: ServiceCenter {
    
    public func register<T: Service>(services: [T], completion: (() -> ())?) {
        let work = { [weak self] in
            guard let this = self else { return }
            this.context.register(services: services)
        }
        if let completion = completion {
            serviceQueue.async {
                work()
                completion()
            }
        } else {
            work()
        }
    }
    
    public func register<T: Service>(service: T, completion: (() -> ())?) {
        let work = { [weak self] in
            guard let this = self else { return }
            this.context.register(service: service)
        }
        if let completion = completion {
            serviceQueue.async {
                work()
                completion()
            }
        } else {
            work()
        }
    }
    
    public func service<T>(for identifier: ServiceIdentifier) -> T? where T : BaseService {
        return context.service(for: identifier)
    }
    
    public func anyService(for identifier: ServiceIdentifier) -> Service? {
        return context.anyService(for: identifier)
    }
    
    public func retrieveService<T>() -> T where T: BaseService {
        let identifier = T.defaultIdentifier
        guard let service: T = context.service(for: identifier) else {
            let service = T()
            context.register(service: service)
            return service
        }
        return service
    }
    
    public func allServices() -> [Service] {
        return context.allServices()
    }
    
    public func unregisterService(with identifier: ServiceIdentifier) {
        context.unregisterService(with: identifier)
    }
    
    public func unregisterAllServices() {
        context.unregisterAllServices()
    }
    
}
