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
    
    func assignNeighbours() {
        for person in AI.people {
            for i in 0..<10 {
                let personCursor = AI.people[i]
                if personCursor.positionVal != person.positionVal {
                    //See left
                    if person.coordinate.x == 0 {
                        person.left = nil
                    } else {
                        if personCursor.coordinate.x + personCursor.width == person.coordinate.x && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.left?.append(personCursor)
                        }
                    }
                    
                    //See right
                    if person.coordinate.x + person.width > 3 {
                        person.right = nil
                    } else {
                        if personCursor.coordinate.x == person.coordinate.x + person.width && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.right?.append(personCursor)
                        }
                    }
                    
                    //See top
                    if person.coordinate.y == 0 {
                        person.top = nil
                    } else {
                        if personCursor.coordinate.y + personCursor.height == person.coordinate.y && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
                            person.top?.append(personCursor)
                        }
                    }
                    
                    //See bottom
                    if person.coordinate.y + person.height > 4 {
                        person.bottom = nil
                    } else {
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
