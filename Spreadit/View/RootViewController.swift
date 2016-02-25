//
//  TutorialViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController, UITabBarControllerDelegate {
    
    lazy var pageViewControllers: [UIViewController] = {
        #if DEBUG
            return [
                self.viewController("HistoryViewController")!,
                self.viewController("SettingsViewController")!,
                self.viewController("TextViewController")!
            ]
        #else
            return [
                self.viewController("HistoryViewController")!,
                self.viewController("SettingsViewController")!,
            ]
        #endif
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = self.pageViewControllers
        self.delegate = self;
    }
    
    func pushViewController(viewController: UIViewController) {
        if let navigationController = self.selectedViewController as? UINavigationController {
            navigationController.pushViewController(viewController, animated: false)
        }
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let navigationController = viewController as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
    }
    
    private func viewController(identifier :String) -> UIViewController? {
        if let viewController = UIViewController.loadFromStoryboard(identifier) {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.translucent = true;
            return navigationController
        }
        return nil
    }
}
