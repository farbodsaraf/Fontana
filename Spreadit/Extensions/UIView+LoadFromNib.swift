//
//  UIView+LoadFromNib.swift
//  Spreadit
//
//  Created by Marko Hlebar on 03/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

extension UIView {
    
    class func loadFromNib(named: String) -> UIView? {
        return NSBundle.mainBundle().loadNibNamed(named,
            owner: self, options: nil).first as? UIView
    }
}