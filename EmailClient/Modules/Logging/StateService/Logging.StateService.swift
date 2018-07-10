//
//  Logging.StateService.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public enum LogRecording {
    
    public typealias Message = IdentifiableEvent
   
    
    /* We are handling generic events with case event(Message, TimeInterval) but you can feel free to
       define something custom for analytics or UIApplication events.
    
       /**
        *  Application
        */
     
        case applicationEvent(ApplicationStateService.Events.ApplicationEvent, TimeInterval)
   
        /**
         *  Analytics
         */
    
        case analyticsEvents(Analytics.Events.AnalyticsEvents, TimeInterval)

    */
 
    case event(Message, TimeInterval)
    case signal(ActionPerformer, TimeInterval)
    case any(Any, TimeInterval)
    
    public func prettyPrint(withInitialStartTime initialTime: TimeInterval) -> String {
        switch self {
        case .event(let event, let time):
            
            // Guard for event name else something very wrong
            guard let name = event.name.components(separatedBy: ".").last else { return "" }
            
            var text = "-------------- \(name) --------------\n"
            text.append("\n")
            text.append("Elapsed Time: " + (time - initialTime).stringFromTimeInterval() + "\n")
            text.append(String.deepDescription(any: event) + "\n")
            text.append("\n")
            return text
            
        case .signal(let actionPerformer, let time):
            
            // Guard for signal name
            
            guard actionPerformer.name.isEmpty else { return "" }
            
            var text = "-------------- \(actionPerformer.name) --------------\n"
            text.append("\n")
            text.append("Elapsed Time: " + (time - initialTime).stringFromTimeInterval() + "\n")
            text.append(String.deepDescription(any: actionPerformer) + "\n")
            text.append("\n")
            return text
        
        case .any(let any, let time):
        
            var text = "-------------- Any --------------\n"
            text.append("\n")
            text.append("Elapsed Time: " + (time - initialTime).stringFromTimeInterval() + "\n")
            text.append(String.deepDescription(any: any) + "\n")
            text.append("\n")
            return text
        }
    }
    
}

public protocol LoggingStateProvider: Service {
    var stateSignal: Signal<LoggingState> { get }
}

public final class LoggingStateService: BaseService, LoggingStateProvider {
    
    // MARK: - Attributes
    
    private let environment: Environment
    let initialTime: TimeInterval
    
    public var stateSignal: Signal<LoggingState> = Signal<LoggingState>(value: LoggingState(loggingText: "", isLogging: true))
    
    // MARK: - Initialization
    
    public required init(withEnvironment environment: Environment) {
        self.environment = environment
        initialTime = CFAbsoluteTimeGetCurrent()
        super.init()
        add(listener: self,
            for: Logging.Events.LogEvent.name,
            handler: LoggingStateService.handleLog)
        add(listener: self,
            for: Logging.Events.ClearLoggingEvent.name,
            handler: LoggingStateService.clearLogging)
    }
    
    @available(*, unavailable)
    public required init() {
        fatalError("init() has not been implemented")
    }
    
    // MARK: - Event Handlers
    
    private func handleLog(_ event: Logging.Events.LogEvent) {
        guard environment != .production else { return }
        let prettyPrint = event.logRecording.prettyPrint(withInitialStartTime: initialTime)
        print(prettyPrint)
        
        // Update state
        let state = stateSignal.value
        var text = state.loggingText
        text.append(prettyPrint)
        let newState = LoggingState(loggingText: text, isLogging: true)
        stateSignal.value = newState
    }
    
    private func clearLogging(_ event: Logging.Events.ClearLoggingEvent) {
        guard environment != .production else { return }
        // Update state
        let newState = LoggingState(loggingText: "", isLogging: true)
        stateSignal.value = newState
    }
    
}

extension ServiceCenter {
    
    public var loggingStateProvider: LoggingStateProvider {
        guard let provider = 👾.service(for: LoggingStateService.defaultIdentifier) as? LoggingStateProvider else {
            let provider: LoggingStateProvider = LoggingStateService(withEnvironment: Environment.currentEnvironment())
            return provider
        }
        return provider
    }
    
}
