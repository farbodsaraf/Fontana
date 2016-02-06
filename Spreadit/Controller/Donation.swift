//
//  Donation.swift
//  Spreadit
//
//  Created by Marko Hlebar on 06/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import Foundation

enum Donation: String {
    case Coffee = "com.fontanakey.donation.tier.1"
    case Snack = "com.fontanakey.donation.tier.2"
    case Lunch = "com.fontanakey.donation.tier.3"
    
    static let allCases = [Coffee, Snack, Lunch]
    
    static func allValues() -> Set<String> {
        let values = NSSet(array: Donation.allCases.map {
            (let enumValue) -> String in
            return enumValue.rawValue
            }) as! Set<String>
        return values
    }
}