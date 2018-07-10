//
//  ExecutionThread.swift
//  SimpleEvent
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 Koin. All rights reserved.
//

import Foundation
import Darwin

//logicTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateModel)];
//logicTimer.frameInterval = kFrameInterval;
//[logicTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//// run the loop - this never returns
//[[NSRunLoop currentRunLoop] run];
public final class ExecutionThread: NSObject {
    private let condition: NSCondition

    let queue: DispatchQueue
    fileprivate var thread: Thread? = nil

    public required override init() {
        self.queue = DispatchQueue(label: String(reflecting: ExecutionThread.self))
        self.condition = NSCondition()
        super.init()
        start()
    }

    deinit {
        stop()
    }

    private func start() {
        let thread = Thread(target: self, selector: #selector(ExecutionThread.main), object: nil)
        self.thread = thread

        condition.lock()
        thread.start()
        condition.wait()
        condition.unlock()
    }


    private func stop() {
        guard let thread = self.thread else { return }

        guard thread != Thread.current else {
            _stop()
            return
        }

        condition.lock()
        self.perform(#selector(ExecutionThread._stop), on: thread, with: nil, waitUntilDone: false)
        condition.wait()
        condition.unlock()
        self.thread = nil
    }

    @objc
    func main() {
        autoreleasepool {
            //            CFRunLoopSourceContext(
            //                version: CFIndex,
            //                info: UnsafeMutableRawPointer!,
            //                retain: ((UnsafeRawPointer?) -> UnsafeRawPointer?)!,
            //                release: ((UnsafeRawPointer?) -> Void)!,
            //                copyDescription: ((UnsafeRawPointer?) -> Unmanaged<CFString>?)!,
            //                equal: ((UnsafeRawPointer?, UnsafeRawPointer?) -> DarwinBoolean)!,
            //                hash: ((UnsafeRawPointer?) -> CFHashCode)!,
            //                schedule: ((UnsafeMutableRawPointer?, CFRunLoop?, CFRunLoopMode?) -> Void)!,
            //                cancel: ((UnsafeMutableRawPointer?, CFRunLoop?, CFRunLoopMode?) -> Void)!,
            //                perform: ((UnsafeMutableRawPointer?) -> Void)!
            //            )

            var context = CFRunLoopSourceContext()
            context.perform = { info in }

            let source = CFRunLoopSourceCreate(
                /*allocator: */nil,
                               /*order: */0,
                                          /*context: */&context)

            CFRunLoopAddSource(
                CFRunLoopGetCurrent(),
                source,
                CFRunLoopMode.commonModes)

            condition.lock()
            condition.signal()
            condition.unlock()

            CFRunLoopRun()

            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, CFRunLoopMode.commonModes)

            condition.lock()
            condition.signal()
            condition.unlock()
        }
    }

    @objc
    private func _stop() {
        CFRunLoopStop(CFRunLoopGetCurrent())
    }

    public func execute(_ closure: @escaping (()->())) {
        queue.async { [weak self] in
            guard
                let this = self,
                let thread = this.thread
                else {
                    return
            }

            let actionHandler = ActionWrapper(action: closure)

            if Thread.current == thread {
                closure()
            } else {
                this.perform(#selector(ExecutionThread.executionHandler), on: thread, with: actionHandler, waitUntilDone: true)
            }
        }
    }

    @objc
    func executionHandler(_ actionHandler: AnyObject) {
        guard Thread.current == thread else {
            print("Not the right thread!")
            return
        }

        guard let actionHandler = actionHandler as? Action else {
            return
        }

        actionHandler.performAction()
    }
}
