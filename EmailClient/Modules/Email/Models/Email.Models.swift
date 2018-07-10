//
//  Email.ManagedObject.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import RealmSwift

public final class EmailManagedObject: Object {
    
    // MARK: - Attributes
    
    @objc public dynamic var id: Int = 0
    @objc public dynamic var subject: String = ""
    @objc public dynamic var from: String = ""
    @objc public dynamic var body: String = ""
    @objc public dynamic var date: Date? = nil
    @objc public dynamic var unread: Bool = false
    
    var to: List<String> = List<String>()
    
    // MARK: - PrimaryKey
    
    override public class func primaryKey() -> String? {
        return #keyPath(EmailManagedObject.id)
    }
    
}

extension EmailManagedObject {
    
    public func `struct`() -> EmailModel {
        return EmailModel(
            id: self.id,
            subject: self.subject,
            from: self.from,
            body: self.body,
            date: self.date?.toString(),
            unread: self.unread,
            to: Array(self.to))
    }
    
}

public struct EmailModel: Codable {
    public let id: Int
    public let subject: String
    public let from: String
    public let body: String
    public let date: String?
    public let unread: Bool
    public let to: [String]
}

extension EmailModel: Equatable {
    public static func ==(lhs: EmailModel, rhs: EmailModel) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.subject != rhs.subject {
            return false
        }
        if lhs.from != rhs.from {
            return false
        }
        if lhs.body != rhs.body {
            return false
        }
        if lhs.date != rhs.date {
            return false
        }
        if lhs.unread != rhs.unread {
            return false
        }
        if lhs.to != rhs.to {
            return false
        }
        return true
    }
}

extension EmailModel {
    
    public func managedObject() -> EmailManagedObject {
        let managedObject = EmailManagedObject()
        managedObject.id = self.id
        managedObject.subject = self.subject
        managedObject.from = self.from
        managedObject.body = self.body
        managedObject.date = self.date?.toDate() ?? Date()
        managedObject.unread = self.unread
        
        let toList = List<String>()
        self.to.forEach { email in toList.append(email) }
        managedObject.to = toList
        
        return managedObject
    }
    
}
