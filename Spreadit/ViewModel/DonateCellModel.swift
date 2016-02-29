//
//  DonateCellModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 04/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

class DonateCellModel: TableRowViewModel {

    lazy var donateText : NSAttributedString = {

        let futureDevelopmentString = "future development board"
        let foodString = "\n\n☕  🍪  🍱\n\n"
        let string: NSString = "We have decided to make this app free because we find it useful and would like to make everyone happy using it. We're investing a lot of our free time and money developing it, so be fair and buy us\(foodString)in return if you like the app. You can check out the\n\n\(futureDevelopmentString)\n\nto vote for upcoming features and participate in the development.\n" as NSString
        
        var donateString = NSMutableAttributedString(string: string as String)
        
        donateString.beginEditing()
        
        donateString.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(14),
            range: NSMakeRange(0, donateString.length))
        
        let foodStringRange = string.rangeOfString(foodString)
        donateString.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(18),
            range: foodStringRange)
        
        let futureDevelopmentStringRange = string.rangeOfString(futureDevelopmentString)
        donateString.addAttribute(NSFontAttributeName,
            value: UIFont.systemFontOfSize(16),
            range: futureDevelopmentStringRange)
        
        donateString.addAttribute(NSLinkAttributeName,
            value: "fontanakey://future",
            range: futureDevelopmentStringRange)
        
        donateString.endEditing()
        
        return donateString.copy() as! NSAttributedString
    }()
    
    override func cellHeight() -> CGFloat {
        return 176
    }
    
    override func identifier() -> String! {
        return "DonateCell"
    }
    
    func donate(donation: Donation) {
        let action = "donate - \(donation.rawValue)"
        FNTAppTracker.trackEvent(FNTAppTrackerActionEvent, withTags: [FNTAppTrackerEventActionTag: action])
        
        DonationStore.defaultStore.buy(donation, completion: {
            (donation: Donation) in
            DonationJar.defaultJar.addDonation(donation)
            
            let action = "did donate - \(donation.rawValue)"
            FNTAppTracker.trackEvent(FNTAppTrackerActionEvent, withTags: [FNTAppTrackerEventActionTag: action])
        })
    }
}
