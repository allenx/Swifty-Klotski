
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
    var st: [String: Int] = [:]
    //inversed
    var ts: [Int: String] = [:]
    
    var fullCodeAt: [Int: String] = [:]
    var parents: [Int] = Array(repeating: 0, count: 30000)
    
    //Array simulating Queue
    var queue: [String] = []
    var swiftyQueue = SwiftyQueue<String>()
    
    //Number of layouts visited so far
    var numberOfLayoutsVisited: Int = 0
    var code: String = ""
    
    var blocks: [Block] = []
    
    func initBoard() {
        blocks.append(Block(_width: 1, _height: 2, _id: 0).set(coordinate: (0, 0)))
        blocks.append(Block(_width: 2, _height: 2, _id: 1).set(coordinate: (1, 0)))
        blocks.append(Block(_width: 1, _height: 2, _id: 2).set(coordinate: (3, 0)))
        blocks.append(Block(_width: 1, _height: 2, _id: 3).set(coordinate: (0, 2)))
        blocks.append(Block(_width: 2, _height: 1, _id: 4).set(coordinate: (1, 2)))
        blocks.append(Block(_width: 1, _height: 1, _id: 5).set(coordinate: (1, 3)))
        blocks.append(Block(_width: 1, _height: 1, _id: 6).set(coordinate: (2, 3)))
        blocks.append(Block(_width: 1, _height: 2, _id: 7).set(coordinate: (3, 2)))
        blocks.append(Block(_width: 1, _height: 1, _id: 8).set(coordinate: (0, 4)))
        blocks.append(Block(_width: 1, _height: 1, _id: 9).set(coordinate: (3, 4)))
    }
    
    func encode() {
        code = ""
        for i in 0..<5 {
            for j in 0..<4 {
                code.append("\(state[i][j].rawValue)")
                code.append(board[i][j] < 0 ? "0" : "\(board[i][j])")
            }
        }
    }
    
    func currentStateCodeFrom(encoding: String) -> String {
        var foo = ""
        for (index, char) in encoding.characters.enumerated() {
            if index % 2 == 0 {
                foo.append(char)
            }
        }
        return foo
    }
    
    func setCurrentBoardFrom(encoding: String) {
        var foo = ""
        foo = currentStateCodeFrom(encoding: encoding)
        print(foo)
        state = Array(repeating: Array(repeating: BlockType.foo, count: 4), count: 5)
        board = Array(repeating: Array(repeating: -1, count: 4), count: 5)
        
        var b = 0
        var c = 0
        for i in 0..<5 {
            for j in 0..<4 {
//                print(foo)
                if foo[c] == "1" {
//                    if blocks.count <= b {
//                        print("\(blocks.count), \(b)")
//                        return
//                    }
//                    print(blocks.count)
                    blocks[b] = Block(_width: 1, _height: 1, _id: Int(encoding[2*c+1])!).set(coordinate: (j, i))
                    b = b + 1
                } else if foo[c] == "2" {
                    blocks[b] = Block(_width: 1, _height: 2, _id: Int(encoding[2*c+1])!).set(coordinate: (j, i))
                    foo = foo.replace(StringAtIndex: c+4, with: "@")
                    b = b + 1
                } else if foo[c] == "3" {
                    blocks[b] = Block(_width: 2, _height: 1, _id: Int(encoding[2*c+1])!).set(coordinate: (j, i))
                    foo = foo.replace(StringAtIndex: c+1, with: "@")
                    b = b + 1
                } else if foo[c] == "4" {
                    blocks[b] = Block(_width: 2, _height: 2, _id: Int(encoding[2*c+1])!).set(coordinate: (j, i))
                    foo = foo.replace(StringAtIndex: c+1, with: "@").replace(StringAtIndex: c+4, with: "@").replace(StringAtIndex: c+5, with: "@")
                    b = b + 1
                }
                c = c + 1
            }
        }
    }
    
//    func printBoard() {
//        for i in 0..<5 {
//            for j in 0..<4 {
//                print(board[i][j] > = 0 ? )
//            }
//        }
//    }
    
    func didWin() -> Bool {
        print(state[3][1].rawValue)
        return (state[3][1].rawValue == state[3][2].rawValue && state[3][2].rawValue == state[4][1].rawValue &&
            state[4][1].rawValue == state[4][2].rawValue && state[4][1].rawValue == 4)
    }
    
    func updateCurrent(subLayout: String, currentLayout: String) {
        queue.append(subLayout)
//        swiftyQueue.enqueue(value: subLayout)
        layoutWasVisited[subLayout] = true
        depthFor[subLayout] = depthFor[currentLayout]! + 1
        ts[numberOfLayoutsVisited] = subLayout
        fullCodeAt[numberOfLayoutsVisited] = code
        st[subLayout] = numberOfLayoutsVisited
        numberOfLayoutsVisited += 1
        parents[st[subLayout]!] = st[currentLayout]!
    }
    
    func move(block: Block, currentLayout: String, direction: Int) -> Bool {
        switch direction {
        case 0:
            if block.canGoLeft {
                block.goLeft {
                    
                }
            }
        case 1:
            if block.canGoRight {
                block.goRight {
                    
                }
            }
        case 2:
            if block.canGoUp {
                block.goUp {
                    
                }
            }
        case 3:
            if block.canGoDown {
                block.goDown {
                    
                }
            }
        default:
            return false
        }
        
        encode()
        let layout = currentStateCodeFrom(encoding: code)
        if layoutWasVisited[layout] == nil {
            updateCurrent(subLayout: layout, currentLayout: currentLayout)
            if didWin() {
                print("We Won!")
                return true
            }
            //Omitted
        }
        
        switch direction {
        case 0:
                block.goRight {
                    
                }
        case 1:
                block.goLeft {
                    
                }
        case 2:
                block.goDown {
                    
                }
        case 3:
                block.goUp {
                    
                }
        default:
            return false
        }
        return false
    }
    
    
    func search() {
        initBoard()
        
        encode()
        print(code)
//        print("fuck"+code)
        let s = currentStateCodeFrom(encoding: code)
        queue.append(s)
//        swiftyQueue.enqueue(value: s)
        layoutWasVisited[s] = true
        depthFor[s] = 0
        ts[numberOfLayoutsVisited] = s
        fullCodeAt[numberOfLayoutsVisited] = code
        
        st[s] = numberOfLayoutsVisited
        numberOfLayoutsVisited += 1
        parents[0] = 0
        
        while queue.count != 0 {
            let cur = queue[0]
            queue.remove(at: 0)

            
            setCurrentBoardFrom(encoding: fullCodeAt[st[cur]!]!)
            encode()
            //print(code)
            for block in blocks {
                if move(block: block, currentLayout: cur, direction: 0) {
                    return
                }
                if move(block: block, currentLayout: cur, direction: 1) {
                    return
                }
                if move(block: block, currentLayout: cur, direction: 2) {
                    return
                }
                if move(block: block, currentLayout: cur, direction: 3) {
                    return
                }
            }
        }
        //print(code)
    }
    
}


extension String {
    
    subscript(idx: Int) -> String {
        guard let strIdx = index(startIndex, offsetBy: idx, limitedBy: endIndex)
            else { fatalError("String index out of bounds") }
        return "\(self[strIdx])"
    }
    
    
    func replace(StringAtIndex: Int, with newChar: Character) -> String {
        var modifiedString = ""
        for (i, char) in self.characters.enumerated() {
            modifiedString += String((i == StringAtIndex) ? newChar : char)
        }
        return modifiedString
    }
    
}
