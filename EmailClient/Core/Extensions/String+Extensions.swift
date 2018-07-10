//
//  String+Extensions.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

extension String {
    
    static func deepDescription(any: Any) -> String {
        guard let any = deepUnwrap(any: any) else {
            return "nil"
        }
        
        if any is Void {
            return "Void"
        }
        
        if let int = any as? Int {
            return String(int)
        } else if let double = any as? Double {
            return String(double)
        } else if let float = any as? Float {
            return String(float)
        } else if let bool = any as? Bool {
            return String(bool)
        } else if let string = any as? String {
            return "\"\(string)\""
        }
        
        let indentedString: ((String) -> String) = {
            $0.components(separatedBy: .newlines).map { $0.isEmpty ? "" : "\r    \($0)" }.joined(separator: "")
        }
        
        let mirror = Mirror(reflecting: any)
        
        let properties = Array(mirror.children)
        
        guard let displayStyle = mirror.displayStyle else {
            return String(describing: any)
        }
        
        switch displayStyle {
        case .tuple:
            if properties.count == 0 { return "()" }
            
            var string = "("
            
            for (index, property) in properties.enumerated() {
                if property.label!.characters.first! == "." {
                    string += deepDescription(any: property.value)
                } else {
                    string += "\(property.label!): \(deepDescription(any: property.value))"
                }
                
                string += (index < properties.count - 1 ? ", " : "")
            }
            
            return string + ")"
        case .collection, .set:
            if properties.count == 0 { return "[]" }
            
            var string = "["
            
            for (index, property) in properties.enumerated() {
                string += indentedString(deepDescription(any: property.value) + (index < properties.count - 1 ? ",\r" : ""))
            }
            
            return string + "\r]"
        case .dictionary:
            if properties.count == 0 { return "[:]" }
            
            var string = "["
            
            for (index, property) in properties.enumerated() {
                let pair = Array(Mirror(reflecting: property.value).children)
                
                string += indentedString("\(deepDescription(any: pair[0].value)): \(deepDescription(any: pair[1].value))" + (index < properties.count - 1 ? ",\r" : ""))
            }
            
            return string + "\r]"
        case .enum:
            if let any = any as? CustomDebugStringConvertible {
                return any.debugDescription
            }
            
            if properties.count == 0 { return "\(mirror.subjectType)." + String(describing: any) }
            
            var string = "\(mirror.subjectType).\(properties.first!.label!)"
            
            let associatedValueString = deepDescription(any: properties.first!.value)
            
            if associatedValueString.characters.first! == "(" {
                string += associatedValueString
            } else {
                string += "(\(associatedValueString))"
            }
            
            return string
        case .struct, .class:
            if let any = any as? CustomDebugStringConvertible {
                return any.debugDescription
            }
            
            if properties.count == 0 { return String(describing: any) }
            
            var string = "<\(mirror.subjectType)"
            
            if displayStyle == .class, let object = any as? AnyObject {
                string += ": \(Unmanaged<AnyObject>.passUnretained(object).toOpaque())"
            }
            
            string += "> {"
            
            for (index, property) in properties.enumerated() {
                string += indentedString("\(property.label!): \(deepDescription(any: property.value))" + (index < properties.count - 1 ? ",\r" : ""))
            }
            
            return string + "\r}"
        case .optional: fatalError("deepUnwrap must have failed...")
        }
    }
    
    static func deepUnwrap(any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        
        if mirror.displayStyle != .optional {
            return any
        }
        
        if let child = mirror.children.first, child.label == "Some" {
            return deepUnwrap(any: child.value)
        }
        
        return nil
    }
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
}
