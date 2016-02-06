//
//  NavigationCell.swift
//  Spreadit
//
//  Created by Marko Hlebar on 02/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class NavigationCell: BNDTableViewCell {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var _bindings :[AnyObject]?
    override internal var bindings:[AnyObject]!  {
        get {
            if _bindings == nil {
                _bindings = [
                    bndBIND(viewModel, "title", "~>", self, "textLabel.text", "", nil)
                ]
            }
            return _bindings
        }
        set {
            _bindings = newValue
        }
    }
}
