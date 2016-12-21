//
//  AI.swift
//  Klotski
//
//  Created by Allen X on 11/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

class AI {
    
    static let shared = AI()
    static let people = [Person.CaoCao, Person.GuanYu, Person.ZhaoYun, Person.ZhangFei, Person.MaChao, Person.HuangZhong, Person.Soldier1, Person.Soldier2, Person.Soldier3, Person.Soldier4]
    static let queue = SwiftyQueue<Layout>()
    static var fooArr: [Layout] = []
    static var valueArr: [(lhs: Int, rhs: Int)] = []
    
    func assignNeighbours() {
        for person in AI.people {
            for i in 0..<10 {
                let personCursor = AI.people[i]
                if personCursor.positionVal != person.positionVal {
                    //See left
                    if person.coordinate.x == 1 {
                        person.left = nil
                    } else {
                        person.left = []
                        if personCursor.coordinate.x + personCursor.width == person.coordinate.x && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.left?.append(personCursor)
                        }
                    }
                    
                    //See right
                    if person.coordinate.x + person.width > 4 {
                        person.right = nil
                    } else {
                        person.right = []
                        if personCursor.coordinate.x == person.coordinate.x + person.width && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.right?.append(personCursor)
                        }
                    }
                    
                    //See top
                    if person.coordinate.y == 1 {
                        person.top = nil
                    } else {
                        person.top = []
                        if personCursor.coordinate.y + personCursor.height == person.coordinate.y && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
                            person.top?.append(personCursor)
                        }
                    }
                    
                    //See bottom
                    if person.coordinate.y + person.height > 5 {
                        person.bottom = nil
                    } else {
                        person.bottom = []
                        if personCursor.coordinate.y == person.coordinate.y + person.height && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
                            person.bottom?.append(personCursor)
                        }
                    }
                }
            }
        }
    }
    
    
    func calculatePositionValues() -> (Int, Int) {
        var lhsStr = ""
        var rhsStr = ""
        for (index, person) in AI.people.enumerated() {
            switch index {
            case 0..<7:
                lhsStr.append("\(person.coordinate.x)\(person.coordinate.y)")
            default:
                rhsStr.append("\(person.coordinate.x)\(person.coordinate.y)")
            }
        }
        return (Int(lhsStr)!, Int(rhsStr)!)
    }
    
    
    func binaryInsert(value: (lhs: Int, rhs: Int)) -> Bool {

        AI.valueArr.append(value)
        let fooCount = AI.valueArr.count
        AI.valueArr = AI.valueArr.removeDuplicates {
            $0.0 == $1.0 && $0.1 == $1.1
        }
        
        if AI.valueArr.count == fooCount {
            return true
        }
        print("剪枝")
        return false
    }
    
    
    func search() {
        let initialLayout = Layout(superLayout: nil, value: calculatePositionValues())
        //AI.queue.enqueue(value: initialLayout)
        AI.fooArr.append(initialLayout)
        while !didWin() {
            //Check if current layout was already visited
            //If not, insert it into the array
            if binaryInsert(value: calculatePositionValues()) {
                assignNeighbours()
                for person in AI.people {
                    if person.left != nil && person.left?.count == 0 {
                        person.goLeft {
                            //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                            //AI.queue.enqueue(value: layout)
                            let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                            AI.fooArr.append(layout)
                        }
                    }
                    if person.right != nil && person.right?.count == 0 {
                        person.goRight {
                            //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                            //AI.queue.enqueue(value: layout)
                            let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                            AI.fooArr.append(layout)
                        }
                    }
                    if person.top != nil && person.top?.count == 0 {
                        person.goUp {
                            //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                            //AI.queue.enqueue(value: layout)
                            let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                            AI.fooArr.append(layout)
                        }
                    }
                    if person.bottom != nil && person.bottom?.count == 0 {
                        person.goDown {
                            //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                            //AI.queue.enqueue(value: layout)
                            let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                            AI.fooArr.append(layout)
                        }
                    }
                }
//                print("队头\(AI.queue._front.value.value)")
//                AI.queue.dequeue(value: AI.queue._front.value)
//                setCurrentPeopleFrom(layout: AI.queue._front.value)
                print(AI.fooArr[0].value)
                print(AI.valueArr.count)
                AI.fooArr.remove(at: 0)
                setCurrentPeopleFrom(layout: AI.fooArr[0])
                
            } else {
                //print(AI.fooArr[0].value)
                //AI.fooArr.remove(at: 0)
                print(AI.fooArr.count)
                print(AI.valueArr.count)
            }
        }
    }
    
    
    func didWin() -> Bool {
        
        if Person.CaoCao.coordinate.x == 2 && Person.CaoCao.coordinate.y == 4 {
            print("We Won!")
            
            backtrack(layout: AI.fooArr[0])
            return true
        }
        return false
    }
    
    func backtrack(layout: Layout) {
        var foo = layout
        var arr: [Layout] = []
        while foo.superLayout != nil {
            arr.append(foo)
            foo = foo.superLayout!
        }
        arr.append(foo)
        let results = arr.reversed()
        print(results.count)
        for result in results {
            print(result.value)
        }
        
    }
    
    func setCurrentPeopleFrom(layout: Layout) {
        let values = ("\(layout.value.lhs)" + "\(layout.value.rhs)").characters.map {
            return Int("\($0)")!
        }
        
        for (index, person) in AI.people.enumerated() {
            person.coordinate = (values[index * 2], values[index * 2 + 1])
        }
    }
}


extension AI {
    
    func areIntersected(lhs: (min: Int, max: Int), rhs: (min: Int, max: Int)) -> Bool {
        if lhs.max - lhs.min > rhs.max - rhs.min {
            if (rhs.max < lhs.max && rhs.max > lhs.min) || (rhs.min > lhs.min && rhs.min < lhs.max) {
                return true
            }
        } else if lhs.max - lhs.min == rhs.max - rhs.min {
            if lhs.max == rhs.max && lhs.min == rhs.min {
                return true
            }
        } else {
            if (lhs.max < rhs.max && lhs.max > rhs.min) || (lhs.min < rhs.max && lhs.min > rhs.min) {
                return true
            }
        }
        return false
    }
}


extension Array {
    func removeDuplicates( includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]{
        var results = [Element]()
        
        forEach { (element) in
            let existingElements = results.filter {
                return includeElement(element, $0)
            }
            if existingElements.count == 0 {
                results.append(element)
            }
        }
        
        return results
    }
}

