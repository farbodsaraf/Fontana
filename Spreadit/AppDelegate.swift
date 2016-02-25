//
//  AppDelegate.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit
import HockeySDK
import iRate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, iRateDelegate {

    var window: UIWindow?

    override class func initialize(){
        let rate = iRate.sharedInstance()
        rate.eventsUntilPrompt = 10;
        rate.daysUntilPrompt = 0;
        rate.remindPeriod = 0;
    }
    
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
        return openUrl(url)
    }
    
    func openUrl(url: NSURL) -> Bool {
        guard url.scheme == "fontanakey" else {
            return false
        }
        
        if (url.absoluteString == "fontanakey://donate") {
            rootViewController().selectedIndex = 1
        }
        else if (url.absoluteString == "fontanakey://usage") {
            let viewController = UIViewController.loadFromStoryboard("VideoViewController") as! VideoViewController
            viewController.selectedIndex = 1
            rootViewController().selectedIndex = 1
            rootViewController().pushViewController(viewController)
            
        }
        else if (url.absoluteString == "fontanakey://installation") {
            let viewController = UIViewController.loadFromStoryboard("VideoViewController") as! VideoViewController
            viewController.selectedIndex = 0
            rootViewController().selectedIndex = 1
            rootViewController().pushViewController(viewController)
        }
        
        return true
    }
    
    func pushOnCurrentNavigationController(viewController: UIViewController) {
        if let navigationController = rootViewController().selectedViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: false)
        }
    }
    
    func rootViewController() -> RootViewController {
        return window!.rootViewController! as! RootViewController
    }
}
