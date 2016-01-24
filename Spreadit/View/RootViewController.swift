//
//  TutorialViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/12/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    
    lazy var pageViewControllers: [UIViewController] = {
        return [
            self.viewController("HistoryViewController"),
            self.viewController("VideoViewController"),
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = self.pageViewControllers
    }
    
    func viewController(identifier :String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier(identifier)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
}
