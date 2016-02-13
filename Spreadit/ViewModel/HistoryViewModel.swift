//
//  HistoryViewModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 13/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class HistoryViewModel: BNDViewModel {

    lazy var welcomeString: NSAttributedString = {
        
        let usageString = "use the keyboard"
        let installString = "install the keyboard"
        let string = "🖖 Welcome to Fontana 🖖\n\nLooks like you haven't\nused the keyboard yet to share stuff.\nTo get instructions on how to\n\n\(installString)\n\nor\n\n\(usageString)\n\nvisit the More section at the bottom,\nor tap on the links above.\n\nHappy sharing 😎" as NSString
        var welcomeString = NSMutableAttributedString(string: string as String)
        
        welcomeString.beginEditing()
        
        welcomeString.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(14),
            range: NSMakeRange(0, welcomeString.length))

        let installLinkRange = string.rangeOfString(installString)
        welcomeString.addAttribute(NSLinkAttributeName,
            value: "fontanakey://installation",
            range: installLinkRange)
        
        welcomeString.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(16),
            range: installLinkRange)
        
        let usageLinkRange = string.rangeOfString(usageString)
        welcomeString.addAttribute(NSLinkAttributeName,
            value: "fontanakey://usage",
            range: usageLinkRange)
        
        welcomeString.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(16),
            range: usageLinkRange)
        
        welcomeString.endEditing()
        
        return welcomeString.copy() as! NSAttributedString
    }()
    
}
