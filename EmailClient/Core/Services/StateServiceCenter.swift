//
//  StateServiceCenter.swift
//  SimpleEvent
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 Koin. All rights reserved.
//

import Foundation

@nonobjc
public var 👾: StateServiceCenter {
    return StateServiceCenter.defaultCenter
}

public protocol StateConfiguration {
    func bootstrap(serviceCenter: StateServiceCenter)
}

public struct BlankStateConfiguration: StateConfiguration {
    
    public func bootstrap(serviceCenter: StateServiceCenter) {
        // Blank
    }
}

open class StateServiceCenter: NSObject {
    
    public fileprivate(set) static var serviceQueue: DispatchQueue = {
        let queue = DispatchQueue(
            label: String(describing: StateServiceCenter.self),
            qos: DispatchQoS.userInteractive
        )
        return queue
    }()
    
    public let context: StateContext
    public let serviceQueue: DispatchQueue
    public static var configuration: StateConfiguration = BlankStateConfiguration()
    public let executionThread: ExecutionThread
    
    required public init(context: StateContext = StateContext()) {
        let executionThread = ExecutionThread()
        self.executionThread = executionThread
        self.context = context
        self.serviceQueue = StateServiceCenter.serviceQueue
        super.init()
    }
    
    public func bootstrap() {
        serviceQueue.sync { // synchronous
            StateServiceCenter.configuration.bootstrap(serviceCenter: self)
        }
    }
    
}

/**
 *  FIXME: For weak services
 */
//public final class ServiceContract: NSObject {
//
//    public internal(set) var identifier: ServiceIdentifier?
//    private weak var serviceCenter: StateContext? = nil
//
//    internal init(identifier: ServiceIdentifier, serviceCenter: StateContext) {
//        self.identifier = identifier
//        self.serviceCenter = serviceCenter
//
//        super.init()
//    }
//
//    @available(*, unavailable)
//    override init() {
//        fatalError()
//    }
//
//    public func unregister() {
//        if let identifier = identifier {
//            serviceCenter?.unregisterService(with: identifier)
//        }
//    }
//
//    deinit {
//        if let identifier = identifier {
//            serviceCenter?.unregisterService(with: identifier)
//        }
//    }
//}

