//
//  Logging.Events.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

extension Logging {
    
    public struct Events {
        public struct LogEvent: IdentifiableEvent {
            public let logRecording: LogRecording
            public init(logRecording: LogRecording) {
                self.logRecording = logRecording
            }
        }
        public struct ClearLoggingEvent: IdentifiableEvent {
            public init() {}
        }
    }
    
}
