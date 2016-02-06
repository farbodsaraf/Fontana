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
        return [
            self.viewController("HistoryViewController")!,
            self.viewController("SettingsViewController")!,
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = self.pageViewControllers
        self.delegate = self;
    }
    
    internal func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let navigationController = viewController as! UINavigationController
        navigationController.popToRootViewControllerAnimated(false)
    }
    
    private func viewController(identifier :String) -> UIViewController? {
        if let viewController = UIViewController.loadFromStoryboard(identifier) {
            var navigationController : UINavigationController
            navigationController = UINavigationController(rootViewController: viewController)
            return navigationController
        }
        return nil
    }
}
