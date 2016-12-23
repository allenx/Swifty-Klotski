//
//  GameScene.swift
//  Swifty-Klotski
//
//  Created by Allen X on 12/23/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    fileprivate let CaoCao: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "CaoCao"))
    fileprivate let GuanYu: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "GuanYu"))
    fileprivate let HuangZhong: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "HuangZhong"))
    fileprivate let MaChao: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "MaChao"))
    fileprivate let ZhangFei: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "ZhangFei"))
    fileprivate let ZhaoYun: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "ZhaoYun"))
    fileprivate let Soldier1: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "Soldier"))
    fileprivate let Soldier2: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "Soldier"))
    fileprivate let Soldier3: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "Soldier"))
    fileprivate let Soldier4: SKSpriteNode = {
        $0.anchorPoint = CGPoint(x: 0, y: 1)
        $0.xScale = 0.4
        $0.yScale = 0.4
        $0.zPosition = 10
        return $0
    }(SKSpriteNode(imageNamed: "Soldier"))
    
    var nodesArray: [SKSpriteNode] = []
    
    var findPathBtn: SpringButton!
    var stepInBtn: SpringButton!
    
    var stepTracker = 0
    
    override func didMove(to view: SKView) {
        refresh()
        nodesArray  = [CaoCao, GuanYu, HuangZhong, MaChao, ZhangFei, ZhaoYun, Soldier1, Soldier2, Soldier3, Soldier4]
        loadSprites()
        loadUI()
        
    }
    
    func loadUI() {
        findPathBtn = SpringButton()
        findPathBtn.backgroundColor = UIColor.brown
        findPathBtn.layer.cornerRadius = 6
        findPathBtn.minimumScale = 0.92
        findPathBtn.frame = CGRect(x: 800, y: 200, width: 200, height: 100)
        findPathBtn.addTarget(self, action: #selector(findPath), for: .touchUpInside)
        self.view?.addSubview(findPathBtn)
        
        stepInBtn = SpringButton()
        stepInBtn.backgroundColor = .green
        stepInBtn.layer.cornerRadius = 6
        stepInBtn.minimumScale = 0.92
        stepInBtn.frame = CGRect(x: 800, y: 400, width: 200, height: 100)
        stepInBtn.addTarget(self, action: #selector(stepIn), for: .touchUpInside)
        self.view?.addSubview(stepInBtn)
    }
    
    func loadSprites() {
        let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.position = CGPoint(x: (self.view?.frame.midX)!, y: (view?.frame.midY)!)
        bgNode.name = "background_node"
        
        bgNode.zPosition = 0
        
        addChild(bgNode)
        
        for node in nodesArray {
            addChild(node)
        }

    }
    
    
    func refresh() {
        CaoCao.position = pointFrom(person: Person.CaoCao)
        GuanYu.position = pointFrom(person: Person.GuanYu)
        HuangZhong.position = pointFrom(person: Person.HuangZhong)
        MaChao.position = pointFrom(person: Person.MaChao)
        ZhangFei.position = pointFrom(person: Person.ZhangFei)
        ZhaoYun.position = pointFrom(person: Person.ZhaoYun)
        Soldier1.position = pointFrom(person: Person.Soldier1)
        Soldier2.position = pointFrom(person: Person.Soldier2)
        Soldier3.position = pointFrom(person: Person.Soldier3)
        Soldier4.position = pointFrom(person: Person.Soldier4)
    }
    
    func findPath() {
        RawAI.shared.search {
            stateLayout in
            RawAI.shared.recursivelyDecode(layout: stateLayout) {
                //refresh()
            }
        }
    }
    
    func stepIn() {
//        print(RawAI.shared.backtrackSteps.count)
//        print(RawAI.shared.backtrackSteps[stepTracker].count)
        for (index, coordinate) in RawAI.shared.backtrackSteps[stepTracker].enumerated() {
            //print(index)
            //RawAI.shared.people[index].coordinate = coordinate
            Person.people[index].coordinate = coordinate
        }
        for person in Person.people {
            print(person.coordinate, terminator: ", ")
        }
        refresh()
        stepTracker += 1
    }
    
    func pointFrom(person: Person) -> CGPoint {
        let convertedX = person.coordinate.x * 142 + 40
        let convertedY = 768 - (person.coordinate.y * 142 + 40)
        return CGPoint(x: convertedX, y: convertedY)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
