//
//  RawAI.swift
//  Klotski
//
//  Created by Allen X on 12/23/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation


class RawAI {
    static let shared = RawAI()
    //Current state of every block on the board
    var state: [[BlockType]] = Array(repeating: Array(repeating: BlockType.foo, count: 4), count: 5)
    //Current infocode of every block of the board
    var board: [[Int]] = Array(repeating: Array(repeating: -1, count: 4), count: 5)
    //A dictionary who stores if a layout was visited
    var layoutWasVisited: [String: Bool] = [:]
    //Depth of the current layout
    var depthFor: [String: Int] = [:]
    //
    var IntFor: [String: Int] = [:]
    //inversed
    var codeFor: [Int: String] = [:]
    
    var fullCodeAt: [Int: String] = [:]
    var parents: [Int] = []
    
    //Array simulating Queue
    var queue: [String] = []
    
    //Number of layouts visited so far
    var numberOfLayoutsVisited: Int = 0
    var code: String = ""
    
    
}
