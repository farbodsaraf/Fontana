//
//  SettingsViewModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 14/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

let kAppStoreURL = "https://itunes.apple.com/us/app/fontanakey/id1069595637?ls=1&mt=8"

class SettingsViewModel: BNDViewModel, UIActivityItemSource {

    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return ""
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        
        let url = NSURL(string: appStoreURL())!
        let message = "Fontana lets you search for links without leaving the chat!\n\(url.absoluteString)"
        
        switch (activityType) {
        case UIActivityTypePostToTwitter:
            return "@fontanakey lets you search for links without leaving the chat!\n\(url.absoluteString)"
        case UIActivityTypePostToFacebook,
             UIActivityTypeCopyToPasteboard:
            return url
        default:
            return message
        }
    }
    
    func appStoreURL() -> String {
        if let urlString = FNTAppTracker.variableForKey("appStoreURL") as? String {
            return urlString
        }
        return kAppStoreURL
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        return "Check Out Fontana"
    }
}
