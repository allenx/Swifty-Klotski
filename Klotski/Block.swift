//
//  Block.swift
//  Klotski
//
//  Created by Allen X on 11/16/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

class Block {
    
    //coordinate of the top-left point of a block
    var x: Int
    var y: Int
    //width and height of the block indicating the role
    var width: Int
    var height: Int
    
    var left: [Block]?
    var right: [Block]?
    var top: [Block]?
    var bottom: [Block]?
    
    init(x: Int, y: Int, width: Int, height: Int, left: [Block]?, right: [Block]?, top: [Block]?, bottom: [Block]?) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.left = left
        self.right = right
        self.top = top
        self.bottom = bottom
    }
    
}


//class Block: NSObject {
//    
//}
