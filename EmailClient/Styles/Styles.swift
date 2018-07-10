//
//  Styles.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit

public struct Styles {
    
    public enum Colors {
        case primaryColor
        case darkPrimaryColor
        case accentColor
        case primaryTextColor
        case secondaryTextColor
        case dividerColor
        
        public var uiColor: UIColor {
            switch self {
            case .primaryColor: return UIColor(red:0.91, green:0.15, blue:0.39, alpha:1.00)
            case .darkPrimaryColor: return UIColor(red:0.75, green:0.12, blue:0.36, alpha:1.00)
            case .accentColor: return UIColor(red:0.33, green:0.44, blue:0.98, alpha:1.00)
            case .primaryTextColor: return UIColor(red:0.13, green:0.13, blue:0.13, alpha:1.00)
            case .secondaryTextColor: return UIColor(red:0.46, green:0.46, blue:0.46, alpha:1.00)
            case .dividerColor: return UIColor(red:0.74, green:0.74, blue:0.74, alpha:1.00)
            }
        }
        
        public var cgColor: CGColor {
            switch self {
            case .primaryColor: return uiColor.cgColor
            case .darkPrimaryColor: return uiColor.cgColor
            case .accentColor: return uiColor.cgColor
            case .primaryTextColor: return uiColor.cgColor
            case .secondaryTextColor: return uiColor.cgColor
            case .dividerColor: return uiColor.cgColor
            }
        }
    }
    
    public enum Fonts: String {
        
        case systemLight
        case systemRegular
        case systemMedium
        case systemSemibold
        case systemBold
        case whitneyKBook = "WhitneyK-Book"
        case whitneyKMedium = "WhitneyK-Medium"
        case whitneyKSemibold = "WhitneyK-Semibold"
        case helveticaNeue = "HelveticaNeue"
        case helveticaNeueLight = "HelveticaNeue-Light"
        case helveticaNeueThin = "HelveticaNeue-Thin"
        case helveticaNeueMedium = "HelveticaNeue-Medium"
        case helveticaNeueBold = "HelveticaNeue-Bold"
        case helveticaNeueCondensedBold = "HelveticaNeue-CondensedBold"
        case avenirNextRegular = "AvenirNext-Regular"
        case avenirNextMedium = "AvenirNext-Medium"
        case avenirNextDemibold = "AvenirNext-DemiBold"
        case dinAlternateBold = "DINAlternate-Bold"
        
        public var defaultWeight: UIFont.Weight {
            switch self {
            case .whitneyKBook: return UIFont.Weight.regular
            case .whitneyKMedium: return UIFont.Weight.medium
            case .whitneyKSemibold: return UIFont.Weight.semibold
            case .helveticaNeue: return UIFont.Weight.regular
            case .helveticaNeueLight: return UIFont.Weight.light
            case .helveticaNeueThin: return UIFont.Weight.thin
            case .helveticaNeueMedium: return UIFont.Weight.medium
            case .helveticaNeueBold: return UIFont.Weight.bold
            case .helveticaNeueCondensedBold: return UIFont.Weight.semibold
            case .avenirNextRegular: return UIFont.Weight.regular
            case .avenirNextMedium: return UIFont.Weight.medium
            case .avenirNextDemibold: return UIFont.Weight.semibold
            case .dinAlternateBold: return UIFont.Weight.bold
            case .systemLight: return UIFont.Weight.light
            case .systemRegular: return UIFont.Weight.regular
            case .systemMedium: return UIFont.Weight.medium
            case .systemSemibold: return UIFont.Weight.semibold
            case .systemBold: return UIFont.Weight.bold
            }
        }
        
        public func font(with size: CGFloat) -> UIFont {
            switch self {
            case .systemLight, .systemRegular, .systemMedium, .systemSemibold, .systemBold:
                return UIFont.systemFont(ofSize: size, weight: defaultWeight)
            default:
                guard
                    let font = UIFont(name: rawValue, size: size)
                    else {
                        return UIFont.systemFont(ofSize: size, weight: defaultWeight)
                }
                return font
            }
        }
        
    }
    
}
