//
//  Email.RealmDomain.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import RealmSwift

public struct EmailRealmDomain: RealmDomain {
    
    public enum SchemaVersion: Int {
        case `default` = 1
    }
    
    public var name: String {
        return "emailclient"
    }
    
    public var location: RealmLocation {
        return .documentsDirectory
    }
    
    public var fileProtection: FileProtectionType {
        return .completeUntilFirstUserAuthentication
    }
    
    public var configuration: Realm.Configuration {
        
        func migrate(_ migration: Migration, _ oldSchemaVersion: UInt64) {
            // please document changes here:
        }
        
        return Realm.Configuration(
            fileURL: self.fileURL,
            inMemoryIdentifier: nil,
            syncConfiguration: nil,
            encryptionKey: nil,
            readOnly: false,
            schemaVersion: UInt64(SchemaVersion.default.rawValue),
            migrationBlock: migrate,
            deleteRealmIfMigrationNeeded: false,
            shouldCompactOnLaunch: nil,
            objectTypes: [
                EmailManagedObject.self
            ]
        )
    }
    
}

extension Realm {
    public static let emailDomain: RealmDomain = EmailRealmDomain()
}
