//
//  UIViewController+LoadFromStoryboard.swift
//  Spreadit
//
//  Created by Marko Hlebar on 03/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

extension UIViewController {
 
    class func loadFromStoryboard(identifier: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
}
