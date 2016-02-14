//
//  SettingsViewModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 14/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

let appStoreURL = "https://itunes.apple.com/us/app/fontanakey/id1069595637?ls=1&mt=8"

class SettingsViewModel: BNDViewModel, UIActivityItemSource {

    func activityViewControllerPlaceholderItem(activityViewController: UIActivityViewController) -> AnyObject {
        return ""
    }
    
    func activityViewController(activityViewController: UIActivityViewController, itemForActivityType activityType: String) -> AnyObject? {
        
        let url = NSURL(string: appStoreURL)!
        let message = "FontanaKey lets you search for URL-s without leaving the chat!\n\(url.absoluteString)"
        
        switch (activityType) {
        case UIActivityTypePostToTwitter:
            return "@fontanakey lets you search for URL-s without leaving the chat!\n\(url.absoluteString)"
        case UIActivityTypePostToFacebook,
             UIActivityTypeCopyToPasteboard:
            return url
        default:
            return message
        }
    }
    
    func activityViewController(activityViewController: UIActivityViewController, subjectForActivityType activityType: String?) -> String {
        return "Check out FontanaKey"
    }
}
