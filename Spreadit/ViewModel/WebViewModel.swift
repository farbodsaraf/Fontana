//
//  WebViewModel.swift
//  Spreadit
//
//  Created by Marko Hlebar on 20/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class WebViewModel: BNDViewModel {
    
    func url() -> NSURL {
        assert(self.model != nil, "Provide a url string as model")
        return NSURL(string: self.model as! String)!
    }
    
    func request() -> NSURLRequest {
        return NSURLRequest(URL: url())
    }
}
