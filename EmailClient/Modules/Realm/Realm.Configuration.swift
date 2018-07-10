//
//  Realm.Configuration.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import RealmSwift

public extension URL {
    public static var documentsDirectory: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0]
        return documentsDirectory
    }
}

public enum RealmLocation {
    
    case documentsDirectory
    
    public var url: URL {
        switch self {
        case .documentsDirectory:
            return URL.documentsDirectory.appendingPathComponent("Realms", isDirectory: true)
        }
    }
}

public protocol RealmDomain {
    var configuration: Realm.Configuration { get }
    var location: RealmLocation { get }
    var realm: Realm { get }
    var name: String { get }
    var `extension`: String { get }
    var folder: URL { get }
    var fileURL: URL { get }
    var fileProtection: FileProtectionType { get }
    func applyFileProtection()
    func deleteRealm()
}

public extension RealmDomain {
    
    public var realm: Realm {
        do {
            let realm = try Realm(configuration: configuration)
            return realm
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
    public var `extension`: String {
        return "realm"
    }
    
    public var folder: URL {
        let folderURL = location.url.appendingPathComponent(
            name.capitalized, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                applyFileProtection()
            } catch {}
        }
        
        return folderURL
    }
    
    public func applyFileProtection() {
        // iOS 8  and above had default file protections
        
        // Get our Realm file's parent directory
        let folderPath = folder.path
        
        // Disable file protection for this directory
        do {
            try FileManager.default.setAttributes(
                [.protectionKey: fileProtection],
                ofItemAtPath: folderPath
            )
        } catch {}
    }
    
    public var fileURL: URL {
        let fileURL: URL = folder.appendingPathComponent("\(name).\(self.extension)", isDirectory: false)
        return fileURL
    }
    
    public func deleteRealm() {
        
        let debugMessage = """
        ❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️
        ❗️            Deleting Realm \(self.name)            ❗️
        ❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️
        """
        
        print(debugMessage)
        
        let realmURL = fileURL
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                // handle error
            }
        }
    }
}

public extension Realm {
    public func work(_ work: ()->(), handleError: ((Swift.Error)->())? = nil) {
        if isInWriteTransaction {
            work()
        } else {
            do {
                try write {
                    work()
                }
            } catch {
                handleError?(error)
            }
        }
    }
}
