//
//  Layout.swift
//  Klotski
//
//  Created by Allen X on 11/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

class Layout {
    //its super layout
    let superLayout: Layout?

    //current layout represented as an Int value
    let value: (lhs: Int, rhs: Int)
//    let valueStr: String {
//        get {
//            return ("\(value.lhs)"+)
//        }
//    }
    
    init(superLayout: Layout?, value: (lhs: Int, rhs: Int)) {
        self.superLayout = superLayout
        self.value = value
    }
}
