//
//  ShareTransformer.swift
//  Spreadit
//
//  Created by Marko Hlebar on 29/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import Foundation

protocol ShareTransformer {
    typealias T
    func transform(object: T, handler: (url : NSURL?) -> Void)
}

