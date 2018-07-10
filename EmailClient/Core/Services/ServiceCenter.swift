//
//  ServiceCenter.swift
//  SimpleEvent
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 Koin. All rights reserved.
//

import Foundation

/**
 *  I want to add UIResponder chain to this so we can bind to views
 */
public protocol ServiceCenter {
    var serviceQueue: DispatchQueue { get }
    func service<T>(for identifier: ServiceIdentifier) -> T? where T: BaseService
    func register<T: Service>(service: T, completion: (()->())?)
    func register<T: Service>(services: [T], completion: (()->())?)
    func anyService(for identifier: ServiceIdentifier) -> Service?
    func retrieveService<T>() -> T where T: BaseService
    func allServices() -> [Service]
    func unregisterService(with identifier: ServiceIdentifier)
    func unregisterAllServices()
}
