//
//  NavigationCellModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 02/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit

class NavigationCellModel: TableRowViewModel {
    
    let title: String
    
    override init!(model: AnyObject!) {
        title = model as! String

        super.init(model: model)
    }
    
    override func identifier() -> String! {
        return "NavigationCell"
    }
}
