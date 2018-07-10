//
//  Network.StateService.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import Moya

public protocol NetworkStateProvider: Service {
    var emailProvider: MoyaProvider<EmailAPIProvider> { get }
    var jsonDecoder: JSONDecoder { get }
}

public final class NetworkStateService: BaseService, NetworkStateProvider {
    
    // MARK: - Associations
    
    typealias `Self` = NetworkStateService
    
    // MARK: - Attributes
    
    private let environment: Environment
    public let emailProvider: MoyaProvider<EmailAPIProvider> = MoyaProvider<EmailAPIProvider>(plugins: [NetworkLoggerPlugin(verbose: true)])
    public let jsonDecoder = JSONDecoder()
    
    // MARK: - Init
    
    public required init(withEnvironment environment: Environment) {
        self.environment = environment
        super.init()
        
        // Register Listeners
        registerListeners()
    }
    
    @available(*, unavailable)
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    private func registerListeners() {
        
    }
    
    // MARK: - Event Listeners
    
    // ...
    
}

extension ServiceCenter {
    
    public var networkStateProvider: NetworkStateProvider {
        guard let provider = 👾.service(for: NetworkStateService.defaultIdentifier) as? NetworkStateProvider else {
            let provider: NetworkStateProvider = NetworkStateService(withEnvironment: Environment.currentEnvironment())
            return provider
        }
        return provider
    }
    
}

