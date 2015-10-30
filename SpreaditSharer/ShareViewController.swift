//
//  ShareViewController.swift
//  SpreaditSharer
//
//  Created by Marko Hlebar on 28/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit
import MobileCoreServices

class ShareViewController: UIViewController {
    
    var alertController : UIAlertController?
    var itunesTransformer : ItunesPlainTextToSpotifyURLTransformer?;

    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        presentAlertViewController(self.parentViewController!)
    }
    
    func presentAlertViewController(let parentViewController : UIViewController) {
        alertController = UIAlertController(title:"Spreadit", message:"", preferredStyle:.ActionSheet)
        
        let defaultAction = UIAlertAction(title: "Convert",
            style: .Default) { [unowned self] (let action : UIAlertAction) -> Void in
                self.handleExtensionContext(self.extensionContext!)
        }
        
        alertController?.addAction(defaultAction);
        presentViewController(alertController!, animated: true, completion: nil)
    }
    
    func handleExtensionContext(let extensionContext : NSExtensionContext) {
        
        let items = extensionContext.inputItems;
        if let item = items.first as! NSExtensionItem? {
            for provider in item.attachments as! [NSItemProvider] {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                    provider.loadItemForTypeIdentifier(kUTTypeURL as String, options: nil) {
                        (url, error) -> Void in
                        print(url)
                    }
                }
                else if provider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
                    provider.loadItemForTypeIdentifier(kUTTypePlainText as String, options: nil) {
                        (text, error) -> Void in
                        var string = String(text)
                        string = string.stringByReplacingOccurrencesOfString("Optional", withString: "")
                        let characterSet = NSCharacterSet(charactersInString: "()")
                        string = string.stringByTrimmingCharactersInSet(characterSet)
                        self.handlePlainText(string)
                    }
                }
                print(provider)
            }
        }
        
        extensionContext.completeRequestReturningItems(nil, completionHandler: nil)
    }
    
    func handlePlainText(plainText: String) {
        itunesTransformer = ItunesPlainTextToSpotifyURLTransformer()
        itunesTransformer?.transform(plainText, handler: { (url) -> Void in
            UIPasteboard.generalPasteboard().URL = url;
        })
    }
}

