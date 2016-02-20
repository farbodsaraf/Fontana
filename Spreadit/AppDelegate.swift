//
//  AppDelegate.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let url = launchOptions?[UIApplicationLaunchOptionsURLKey] as? NSURL
        FNTAppTracker.sharedInstance().startWithPreviewURL(url)
        
        let urlCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024, diskCapacity: 20 * 1024 * 1024, diskPath: nil)
        NSURLCache.setSharedURLCache(urlCache)
        
        NSSetUncaughtExceptionHandler { (exception : NSException) -> Void in
            print(exception.callStackSymbols)
        }
        
        UINavigationBar.appearance().titleTextAttributes = [ NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = UIColor.fnt_teal()

        UITabBar.appearance().tintColor = UIColor.fnt_teal()
        
        BITHockeyManager.sharedHockeyManager().configureWithIdentifier("9bc7ee209ec3404dba1ec07b94cca99e");
        BITHockeyManager.sharedHockeyManager().startManager();
        BITHockeyManager.sharedHockeyManager().authenticator.authenticateInstallation();
        
        DonationStore.defaultStore.loadProducts()
        
        return true
    }
    
    func openURLIfNeeded(options: [NSObject: AnyObject]) {
        if let url = options[UIApplicationLaunchOptionsURLKey] {
            openUrl(url as! NSURL)
        }
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        openUrl(url)
        return true
    }
    
    func openUrl(url: NSURL) {
        if (url.absoluteString == "fontanakey://donate") {
            let rootViewController = window!.rootViewController! as! RootViewController;
            rootViewController.selectedIndex = 1
        }
    }
}
