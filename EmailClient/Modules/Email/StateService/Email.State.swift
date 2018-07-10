//
//  Email.State.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct ErrorModel: Codable {
    
    public enum ErrorType: String, Codable {
        case realm
        case network
        case other
    }
    
    public let localizedDescription: String
    public let type: ErrorType
    public init(error: Error, type: ErrorType) {
        self.localizedDescription = error.localizedDescription
        self.type = type
    }
    
    public init() {
        self.localizedDescription = ""
        self.type = .other
    }
    
    public static func emptyError() -> ErrorModel {
        return ErrorModel()
    }
}

extension ErrorModel: Equatable {
    public static func ==(lhs: ErrorModel, rhs: ErrorModel) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}

public struct EmailState: Codable {
    public let unreadEmails: [EmailModel]
    public let readEmails: [EmailModel]
    
    public func isEmpty() -> Bool {
        return unreadEmails.isEmpty && readEmails.isEmpty
    }
    
    public static func emptyState() -> EmailState {
        return EmailState(unreadEmails: [],
                          readEmails: [])
    }
}

extension EmailState: Equatable {
    public static func ==(lhs: EmailState, rhs: EmailState) -> Bool {
        if lhs.readEmails != rhs.readEmails {
            return false
        }
        if lhs.unreadEmails != rhs.unreadEmails {
            return false
        }
        return true
    }
}
