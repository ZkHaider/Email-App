//
//  Email.Events.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

extension Email {
    
    public struct Events {
        public struct ViewDidLoad: IdentifiableEvent {}
        public struct GetEmailsEvent: IdentifiableEvent {}
        public struct MarkAsReadEvent: IdentifiableEvent {
            public let email: EmailModel
            public init(email: EmailModel) {
                self.email = email
            }
        }
        public struct MarkAsUnReadEvent: IdentifiableEvent {
            public let email: EmailModel
            public init(email: EmailModel) {
                self.email = email
            }
        }
    }
    
}
