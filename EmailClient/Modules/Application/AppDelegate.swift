//
//  AppDelegate.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import UIKit
import RealmSwift

public enum Environment {
    case production
    case debug
    case testing
    public static func currentEnvironment() -> Environment {
        #if DEBUG
        return .debug
        #else
        return .production
        #endif
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window: UIWindow = UIWindow(frame: .zero)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // To clear realm uncomment this if you want to add more objects or changes to realm
//        Realm.emailDomain.deleteRealm()
        
        UIApplication.shared.statusBarView?.backgroundColor = Styles.Colors.darkPrimaryColor.uiColor
        
        // Bootstrap our services
        👾.setConfiguration()
        👾.bootstrap()
        
        // Initialize our entry email view controller
        window.rootViewController = EmailViewController()
        window.makeKeyAndVisible()
        
        return true
    }

}

extension UIApplication {
    
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
    
}

