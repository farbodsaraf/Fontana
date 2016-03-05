//
//  TableRowViewModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 02/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class TableRowViewModel: BNDViewModel, BNDTableRowViewModel {
    
    func cellHeight() -> CGFloat {
        return 44
    }

    override func identifier() -> String! {
        return "Generic"
    }
    
    func select() {
        
    }
}
