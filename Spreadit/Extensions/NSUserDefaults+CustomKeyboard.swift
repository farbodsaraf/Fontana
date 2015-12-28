//
//  NSUserDefaults+CustomKeyboard.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import Foundation

extension NSUserDefaults {
        
    class func isKeyboardEnabled(keyboardBundleID : String) -> Bool {
        let appleKeyboards = "AppleKeyboards"
        let keyboards = self.standardUserDefaults().dictionaryRepresentation()[appleKeyboards] as! [String]
        return (keyboards.filter() { $0 == keyboardBundleID }).count != 0
    }
    
    class func isFullAccessAllowed(keyboardBundleID : String) -> Bool {
        return UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    }
}