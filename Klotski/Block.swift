//
//  Block.swift
//  Klotski
//
//  Created by Allen X on 12/23/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

enum BlockType {
    case horizontal
    case vertical
    case bigSquare
    case tinySquare
    case foo
}

struct Block {
    var coordinate: (x: Int, y: Int)
    
    fileprivate let _width: Int
    fileprivate let _height: Int
    fileprivate let _id: Int
    
    var width: Int {
        get {
            return _width
        }
    }
    var height: Int {
        get {
            return _height
        }
    }
    var id: Int {
        get {
            return _id
        }
    }
    
    var type: BlockType {
        get {
            if _width == 1 && _height == 1 {
                return .tinySquare
            }
            if _width == 1 && _height == 2 {
                return .vertical
            }
            if _width == 2 && _height == 1 {
                return .horizontal
            }
            if _width == 2 && _height == 2 {
                return .bigSquare
            }
            return .bigSquare
        }
    }
    
    init(_width: Int, _height: Int, _id: Int, coordinate: (x: Int, y: Int)) {
        self._width = _width
        self._height = _height
        self._id = _id
        self.coordinate = coordinate
        for i in coordinate.y..<coordinate.y+_height {
            for j in coordinate.x..<coordinate.x+_width {
                RawAI.shared.state[i][j] = type
                RawAI.shared.board[i][j] = id
            }
        }
    }
    
    var canGoLeft: Bool {
        get {
            if coordinate.x == 0 {
                return false
            }
            if RawAI.shared.state[coordinate.y][coordinate.x-1] == .foo && RawAI.shared.state[coordinate.y+_height-1][coordinate.x-1] == .foo {
                return true
            }
            return false
        }
    }
    
    var canGoRight: Bool {
        get {
            if coordinate.x + _width - 1 == 3 {
                return false
            }
            if RawAI.shared.state[coordinate.y][coordinate.x+_width] == .foo && RawAI.shared.state[coordinate.y+_height-1][coordinate.x+_width] == .foo {
                return true
            }
            return false
        }
    }
    
    var canGoUp: Bool {
        get {
            if coordinate.y == 0 {
                return false
            }
            if RawAI.shared.state[coordinate.y-1][coordinate.x] == .foo && RawAI.shared.state[coordinate.y-1][coordinate.x+_width-1] == .foo {
                return true
            }
            return false
        }
        
    }
    
    var canGoDown: Bool {
        get {
            if coordinate.y + _height - 1 == 4 {
                return false
            }
            if RawAI.shared.state[coordinate.y+_height][coordinate.x] == .foo && RawAI.shared.state[coordinate.y+_height][coordinate.x+_width-1] == .foo {
                return true
            }
            return false
        }
    }
    
    mutating func goLeft(and completion: () -> ()) {
        RawAI.shared.state[coordinate.y][coordinate.x+_width-1] = .foo
        RawAI.shared.state[coordinate.y+_height-1][coordinate.x+_width-1] = .foo
        
        RawAI.shared.board[coordinate.y][coordinate.x+_width-1] = -1
        RawAI.shared.board[coordinate.y+_height - 1][coordinate.x+_width-1] = -1
        RawAI.shared.state[coordinate.y][coordinate.x-1] = type
        RawAI.shared.state[coordinate.y+_height-1][coordinate.x-1] = type
        RawAI.shared.board[coordinate.y][coordinate.x-1] = id
        RawAI.shared.board[coordinate.y+_height-1][coordinate.x-1] = id
        
        coordinate.x -= 1;
        completion()
    }
    
    mutating func goRight(and completion: () -> ()) {
        RawAI.shared.state[coordinate.y][coordinate.x] = .foo
        RawAI.shared.state[coordinate.y+_height-1][coordinate.x] = .foo
        
        RawAI.shared.board[coordinate.y][coordinate.x] = -1
        RawAI.shared.board[coordinate.y+_height - 1][coordinate.x] = -1
        RawAI.shared.state[coordinate.y][coordinate.x+_width] = type
        RawAI.shared.state[coordinate.y+_height-1][coordinate.x+_width] = type
        RawAI.shared.board[coordinate.y][coordinate.x+_width] = id
        RawAI.shared.board[coordinate.y+_height-1][coordinate.x+_width] = id
        
        coordinate.x += 1;
        completion()
    }
    
    mutating func goUp(and completion: () -> ()) {
        RawAI.shared.state[coordinate.y+_height-1][coordinate.x] = .foo
        RawAI.shared.state[coordinate.y+_height-1][coordinate.x+_width-1] = .foo
        
        RawAI.shared.board[coordinate.y+_height-1][coordinate.x] = -1
        RawAI.shared.board[coordinate.y+_height-1][coordinate.x+_width-1] = -1
        RawAI.shared.state[coordinate.y-1][coordinate.x] = type
        RawAI.shared.state[coordinate.y-1][coordinate.x+_width-1] = type
        RawAI.shared.board[coordinate.y-1][coordinate.x] = id
        RawAI.shared.board[coordinate.y-1][coordinate.x+_width-1] = id
        
        coordinate.y -= 1
        completion()
    }
    
    mutating func goDown(and completion: () -> ()) {
        RawAI.shared.state[coordinate.y][coordinate.x] = .foo
        RawAI.shared.state[coordinate.y][coordinate.x+_width-1] = .foo
        
        RawAI.shared.board[coordinate.y][coordinate.x] = -1
        RawAI.shared.board[coordinate.y][coordinate.x+_width-1] = -1
        RawAI.shared.state[coordinate.y+_height][coordinate.x] = type
        RawAI.shared.state[coordinate.y+_height][coordinate.x+_width-1] = type
        RawAI.shared.board[coordinate.y+_height][coordinate.x] = id
        RawAI.shared.board[coordinate.y+_height][coordinate.x+_width-1] = id
        
        coordinate.y += 1
        completion()
    }
    
}
