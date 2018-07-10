//
//  Signal.swift
//  SimpleEvent
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 Koin. All rights reserved.
//

import Foundation

public struct Signal<E: Equatable> {
    
    public typealias Listener = ((E) -> ())
    
    private let producer: SignalProducer<E>
    
    public init(value: E) {
        self.producer = SignalProducer(value: value)
    }
    
    public var value: E {
        get { return producer.value }
        set { producer.value = newValue }
    }
    
    public func invoke() {
        producer.signal()
    }
    
    public func add<T: AnyObject>(target: T, action: @escaping (T) -> ((E) -> ())) {
        producer.add(target: target, action: action)
    }
    
    public func remove(target: AnyObject) {
        producer.remove(target: target)
    }
    
    public func removeAllListeners() {
        producer.removeAllListeners()
    }
    
}

public class SignalProducer<E: Equatable> {
    
    internal typealias KindOfEvent = E
    internal let methodMap = NSMapTable<AnyObject, ActionPerformer>(keyOptions: NSPointerFunctions.Options.weakMemory, valueOptions: NSPointerFunctions.Options.strongMemory)
    
    var value: E {
        didSet {
            cachedValue = value
        }
    }
    
    private var cachedValue: E {
        didSet {
            if cachedValue != oldValue {
                signal()
            }
        }
    }
    
    fileprivate func signal() {
        guard let enumerator = methodMap.objectEnumerator() else { return }
        for case let method as ActionPerformer in enumerator {
            👾.loggingStateProvider.dispatch(Logging.Events.LogEvent(
                logRecording: .signal(method, CFAbsoluteTimeGetCurrent()))
            )
            method.tryAction(event: value)
        }
    }
    
    init(value: E) {
        self.value = value
        self.cachedValue = value
    }
    
    func add<T: AnyObject>(target: T, action: @escaping (T) -> ((E) -> ())) {
        let actionEvent = TargetActionEventWrapper<T, E>(target: target, action: action)
        methodMap.setObject(actionEvent, forKey: target)
    }
    
    func remove(target: AnyObject) {
        methodMap.removeObject(forKey: target)
    }
    
    func removeAllListeners() {
        methodMap.removeAllObjects()
    }
    
}

public protocol Action {
    func performAction()
}

public struct TargetActionWrapper<T: AnyObject> : Action {
    public typealias MethodHandler = (T) -> () -> ()
    
    private weak var target: T?
    private let action: MethodHandler
    
    public init(target: T, action: @escaping MethodHandler) {
        self.target = target
        self.action = action
    }
    
    public func performAction() -> () {
        if let target = target {
            action(target)()
        }
    }
}

public struct ActionWrapper : Action {
    public typealias ClosureHandler = () -> ()
    
    private let action: ClosureHandler
    
    public init(action: @escaping ClosureHandler) {
        self.action = action
    }
    
    public func performAction() -> () {
        action()
    }
}

public class ActionPerformer: NSObject {
    func tryAction(event: Any?) {}
    public var name: String {
        return String(reflecting: self).components(separatedBy: ".").last ?? ""
    }
}

public class TargetActionEventWrapper<T: AnyObject, E>: ActionPerformer {
    
    public typealias KindOfEvent = E
    public typealias MethodHandler = (T) -> ((KindOfEvent) -> ())
    public typealias Target = T
    
    public private(set) weak var target: Target?
    public var targetObject: AnyObject? {
        return target
    }
    
    private let action: MethodHandler
    
    public init(target: Target, action: @escaping MethodHandler) {
        self.target = target
        self.action = action
    }
    
    public func performAction(event: KindOfEvent) -> () {
        guard let target = target else { return }
        action(target)(event)
    }
    
    public override func tryAction(event: Any?) {
        guard let typedEvent = event as? KindOfEvent else { return }
        performAction(event: typedEvent)
    }
    
}
