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
    static var dic: [String: Bool] = [:]
    
    func assignNeighbours() {
        for person in AI.people {
            person.left = []
            person.right = []
            person.top = []
            person.bottom = []
            for i in 0..<10 {
                let personCursor = AI.people[i]
                if personCursor.positionVal != person.positionVal {
                    //See left
                    if person.coordinate.x == 1 {
                        person.left = nil
                    } else {
                        //                        person.left = []
                        if personCursor.coordinate.x + personCursor.width == person.coordinate.x && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.left?.append(personCursor)
                        }
                    }
                    
                    //See right
                    if person.coordinate.x + person.width > 4 {
                        person.right = nil
                    } else {
                        //                        person.right = []
                        if personCursor.coordinate.x == person.coordinate.x + person.width && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.right?.append(personCursor)
                        }
                    }
                    
                    //See top
                    if person.coordinate.y == 1 {
                        person.top = nil
                    } else {
                        //                        person.top = []
                        if personCursor.coordinate.y + personCursor.height == person.coordinate.y && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
                            person.top?.append(personCursor)
                        }
                    }
                    
                    //See bottom
                    if person.coordinate.y + person.height > 5 {
                        person.bottom = nil
                    } else {
                        //                        person.bottom = []
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
    
    func calculatePositionString() -> String {
        var foo = ""
        for person in AI.people {
            foo.append("\(person.coordinate.x)")
            foo.append("\(person.coordinate.y)")
        }
        return foo
    }
    
    func binarySearch(array: [(lhs: Int, rhs: Int)], value: (lhs: Int, rhs: Int)) -> (didFind: Bool, index: Int?) {
        
        if array.count == 0 {
            return (false, 0)
        }
        
        var lowerIndex = 0
        var upperIndex = array.count - 1
        
        while lowerIndex <= upperIndex {
            let currentIndex = (lowerIndex + upperIndex) / 2
            let foo = array[currentIndex]
            if foo.lhs == value.lhs {
                if foo.rhs == value.rhs {
                    return (true, nil)
                }
                if foo.rhs < value.rhs {
                    return (false, currentIndex + 1)
                }
                return (false, currentIndex)
            }
            if foo.lhs < value.lhs {
                
            } else {
                
            }
            
        }
        
        return (false, 1)
    }
    
    
    func binaryInsert(value: (lhs: Int, rhs: Int)) -> Bool {
        var lowerIndex = 0
        var upperIndex = AI.valueArr.count - 1
        var currentIndex: Int = 0
        
        
        if AI.valueArr.count == 0 {
            AI.valueArr.insert(value, at: currentIndex)
            return true
        }
        
        while lowerIndex <= upperIndex {
            //print("Searching")
            currentIndex = (upperIndex - lowerIndex) / 2 + lowerIndex
            if AI.valueArr[currentIndex].lhs == value.lhs {
                if AI.valueArr[currentIndex].rhs == value.rhs {
                    print("Pruned")
                    return false
                }
                if AI.valueArr[currentIndex].rhs < value.rhs {
                    AI.valueArr.insert(value, at: currentIndex + 1)
                    return true
                } else {
                    AI.valueArr.insert(value, at: currentIndex)
                    return true
                }
            } else {
                if AI.valueArr[currentIndex].lhs > value.lhs {
                    upperIndex = currentIndex - 1
                } else {
                    lowerIndex = currentIndex + 1
                }
            }
        }
        AI.valueArr.insert(value, at: currentIndex)
        return true
    }
    
    
    func binaryInsert1(value: (lhs: Int, rhs: Int)) -> Bool {
        
        AI.valueArr.append(value)
        
        let fooCount = AI.valueArr.count
        AI.valueArr = AI.valueArr.removeDuplicates {
            $0 == $1
        }
        
        return AI.valueArr.count == fooCount
        
    }
    
    
    func insert(value: (lhs: Int, rhs: Int)) -> Bool {
        for eachValue in AI.valueArr {
            if value == eachValue {
                return false
            }
        }
        let index = Int(Random.random(number: UInt32(AI.valueArr.count)))
        AI.valueArr.insert(value, at: index)
        //AI.valueArr.append(value)
        return true
    }
    
    func search() {
        let initialLayout = Layout(superLayout: nil, value: calculatePositionValues())
        //AI.queue.enqueue(value: initialLayout)
        AI.fooArr.append(initialLayout)
        while !didWin() {
            //Check if current layout was already visited
            //If not, insert it into the array
            if binaryInsert(value: AI.fooArr[0].value) {
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
                
                
                AI.fooArr.remove(at: 0)
                setCurrentPeopleFrom(layout: AI.fooArr[0])
                
            } else {
                
                AI.fooArr.remove(at: 0)
                setCurrentPeopleFrom(layout: AI.fooArr[0])
                
            }
        }
    }
    
    
    func search2() {
        let initialLayout = Layout(superLayout: nil, value: calculatePositionValues())
        //AI.queue.enqueue(value: initialLayout)
        AI.fooArr.append(initialLayout)
        while !didWin() {
            //Check if current layout was already visited
            //If not, insert it into the array
            if insert(value: AI.fooArr[0].value) {
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
                
                print("格局表")
                print(AI.valueArr.count)
                for foo in AI.fooArr {
                    print(foo.value)
                }
                print("队头格局")
                print(AI.fooArr[0].value)
                
                AI.fooArr.remove(at: 0)
                setCurrentPeopleFrom(layout: AI.fooArr[0])
                
            } else {
                AI.fooArr.remove(at: 0)
                setCurrentPeopleFrom(layout: AI.fooArr[0])
            }
        }
    }
    
    
    
    //FIXME: HELP ALLENX, HE IS TOO STUPID!!! WANG FEI WANGBULEI XIAOWANGSHU
    func randomSearch() {
        let initialLayout = Layout(superLayout: nil, value: calculatePositionValues())
        //AI.queue.enqueue(value: initialLayout)
        AI.fooArr.append(initialLayout)
        AI.dic[calculatePositionString()] = true
        while !didWin() {
            //Check if current layout was already visited
            //If not, insert it into the array
            assignNeighbours()
            var indexArr: [Int] = []
            while indexArr.count < 10 {
                let index = Random.random(number: 10)
                indexArr.append(Int(index))
                indexArr = indexArr.removeDuplicates {
                    $0 == $1
                }
            }
            
            for index in indexArr {
                let person = AI.people[index]
                var directionArr: [Int] = []
                while directionArr.count < 4 {
                    let direction = Random.random(number: 4)
                    directionArr.append(Int(direction))
                    directionArr = directionArr.removeDuplicates {
                        $0 == $1
                    }
                }
                
                for direction in directionArr {
                    switch direction {
                    case 0:
                        if person.left != nil && person.left?.count == 0 {
                            person.goLeft {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    case 1:
                        if person.right != nil && person.right?.count == 0 {
                            person.goRight {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    case 3:
                        if person.top != nil && person.top?.count == 0 {
                            person.goUp {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    default:
                        if person.bottom != nil && person.bottom?.count == 0 {
                            person.goDown {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                        
                    }
                }
                
            }
            
            print("格局表")
            AI.dic[calculatePositionString()] = true
            print("队头格局")
            print(AI.fooArr[0].value)
            
            AI.fooArr.remove(at: 0)
            setCurrentPeopleFrom(layout: AI.fooArr[0])
            
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
    
    
    func randomSearch1() {
        let initialLayout = Layout(superLayout: nil, value: calculatePositionValues())
        //AI.queue.enqueue(value: initialLayout)
        AI.fooArr.append(initialLayout)
        while !didWin() {
            //Check if current layout was already visited
            //If not, insert it into the array
            assignNeighbours()
            var indexArr: [Int] = []
            while indexArr.count < 10 {
                let index = Random.random(number: 10)
                indexArr.append(Int(index))
                indexArr = indexArr.removeDuplicates {
                    $0 == $1
                }
            }
            
            for index in indexArr {
                let person = AI.people[index]
                var directionArr: [Int] = []
                while directionArr.count < 4 {
                    let direction = Random.random(number: 4)
                    directionArr.append(Int(direction))
                    directionArr = directionArr.removeDuplicates {
                        $0 == $1
                    }
                }
                
                for direction in directionArr {
                    switch direction {
                    case 0:
                        if person.left != nil && person.left?.count == 0 {
                            person.goLeft {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.dic[calculatePositionString()] = true
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    case 1:
                        if person.right != nil && person.right?.count == 0 {
                            person.goRight {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.dic[calculatePositionString()] = true
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    case 3:
                        if person.top != nil && person.top?.count == 0 {
                            person.goUp {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.dic[calculatePositionString()] = true
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    default:
                        if person.bottom != nil && person.bottom?.count == 0 {
                            person.goDown {
                                //let layout = Layout(superLayout: AI.queue._front.value, value: calculatePositionValues())
                                //AI.queue.enqueue(value: layout)
                                let layout = Layout(superLayout: AI.fooArr[0], value: calculatePositionValues())
                                if AI.dic[calculatePositionString()] == nil {
                                    AI.dic[calculatePositionString()] = true
                                    AI.fooArr.append(layout)
                                }
                            }
                        }
                    }
                }
                
            }
            
            print("格局表")
            print(AI.valueArr.count)
            //                for foo in AI.fooArr {
            //                    print(foo.value)
            //                }
            print("队头格局")
            print(AI.fooArr[0].value)
            
            AI.fooArr.remove(at: 0)
            setCurrentPeopleFrom(layout: AI.fooArr[0])
            
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
            if (lhs.max == rhs.max && lhs.min == rhs.min) || (rhs.max < lhs.max && rhs.max > lhs.min) || (rhs.min > lhs.min && rhs.min < lhs.max) || (lhs.max < rhs.max && lhs.max > rhs.min) || (lhs.min < rhs.max && lhs.min > rhs.min) {
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

