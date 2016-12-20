//
//  Person.swift
//  Klotski
//
//  Created by Allen X on 12/20/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import Foundation

class Person {
    let name: String
    let width: Int
    let height: Int
    
    var coordinate: (x: Int, y: Int)
    var positionVal: Int {
        get {
            return coordinate.x * 10 + coordinate.y
        }
    }
    
    var left: [Person]? = []
    var right: [Person]? = []
    var top: [Person]? = []
    var bottom: [Person]? = []
    
    init(width: Int, height: Int, coordinate: (x: Int, y: Int), name: String) {
        self.width = width
        self.height = height
        self.coordinate = coordinate
        self.name = name
    }
    
    static let CaoCao = Person(width: 2, height: 2, coordinate: (1, 0), name: "曹操")
    static let GuanYu = Person(width: 2, height: 1, coordinate: (1, 2), name: "关羽")
    static let ZhaoYun = Person(width: 1, height: 2, coordinate: (0, 0), name: "赵云")
    static let ZhangFei = Person(width: 1, height: 2, coordinate: (3, 2), name: "张飞")
    static let MaChao = Person(width: 1, height: 2, coordinate: (0, 2), name: "马超")
    static let HuangZhong = Person(width: 1, height: 2, coordinate: (3, 0), name: "黄忠")
    static let Soldier1 = Person(width: 1, height: 1, coordinate: (0, 4), name: "士兵1")
    static let Soldier2 = Person(width: 1, height: 1, coordinate: (1, 3), name: "士兵2")
    static let Soldier3 = Person(width: 1, height: 1, coordinate: (2, 3), name: "士兵3")
    static let Soldier4 = Person(width: 1, height: 1, coordinate: (3, 4), name: "士兵4")

}
