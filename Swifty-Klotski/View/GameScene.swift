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
    
    fileprivate var ai: RawAI!
    
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
    
    var optionsArr: [SpringButton] = []
    
    var findPathBtn: SpringButton!
    var stepInBtn: SpringButton!
    
    var stepTracker = 0
    
    var sound = SKAction.playSoundFileNamed("jingetiema.mp3", waitForCompletion: false)
    let audioNode = SKAudioNode(fileNamed: "jingetiema.mp3")
    
    override func didMove(to view: SKView) {
        addChild(audioNode)
        nodesArray = [ZhaoYun, CaoCao, HuangZhong, MaChao, GuanYu, Soldier1, Soldier2, ZhangFei, Soldier3, Soldier4]
        loadSprites()
        loadUI()
        
    }
    
    func loadUI() {
        findPathBtn = SpringButton()
        findPathBtn.backgroundColor = UIColor(red:0.49, green:0.12, blue:0.11, alpha:0.66)
//        findPathBtn.setBackgroundImage(#imageLiteral(resourceName: "helpCaoCaoBlack"), for: .normal)
        findPathBtn.setImage(#imageLiteral(resourceName: "helpCaoCaoWhite"), for: .normal)
        findPathBtn.imageView?.contentMode = .scaleAspectFit
        findPathBtn.layer.cornerRadius = 6
        findPathBtn.minimumScale = 0.92
        findPathBtn.frame = CGRect(x: 735, y: 40, width: 200, height: 80)
        findPathBtn.addTarget(self, action: #selector(start), for: .touchUpInside)
        self.view?.addSubview(findPathBtn)
        
        let HengDaoLiMaBtn: SpringButton = {
            $0.backgroundColor = UIColor(red:0.49, green:0.12, blue:0.11, alpha:0.66)
            $0.setImage(#imageLiteral(resourceName: "HengDaoLiMaWhite"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 6
            $0.minimumScale = 0.92
            $0.frame = CGRect(x: 735, y: 130, width: 160, height: 80)
            $0.addTarget(self, action: #selector(setHengDaoLiMa), for: .touchUpInside)
            return $0
        }(SpringButton())
        
        let BingLinCaoYingBtn: SpringButton = {
            $0.backgroundColor = UIColor(red:0.49, green:0.12, blue:0.11, alpha:0.66)
            $0.setImage(#imageLiteral(resourceName: "binglincaoying"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            $0.layer.cornerRadius = 6
            $0.minimumScale = 0.92
            $0.frame = CGRect(x: 735, y: 220, width: 160, height: 80)
            $0.addTarget(self, action: #selector(setBingLinCaoYing), for: .touchUpInside)
            return $0
        }(SpringButton())
        
        let CengCengSheFangBtn: SpringButton = {
            $0.backgroundColor = UIColor(red:0.49, green:0.12, blue:0.11, alpha:0.66)
            $0.setImage(#imageLiteral(resourceName: "cengcengshefang"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit

            $0.layer.cornerRadius = 6
            $0.minimumScale = 0.92
            $0.frame = CGRect(x: 735, y: 310, width: 160, height: 80)
            $0.addTarget(self, action: #selector(setCengCengSheFang), for: .touchUpInside)
            return $0
        }(SpringButton())
        
        let BingJiangLianFangBtn: SpringButton = {
//            $0.backgroundColor = UIColor(red:0.49, green:0.12, blue:0.11, alpha:0.66)
            $0.backgroundColor = .clear
            $0.setImage(#imageLiteral(resourceName: "bingjianglianfang"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit
            let blurEffect = UIBlurEffect(style: .dark)
            let frostedView = UIVisualEffectView(effect: blurEffect)
            $0.layer.cornerRadius = 6
            $0.minimumScale = 0.92
            $0.frame = CGRect(x: 735, y: 400, width: 160, height: 80)
            frostedView.frame = $0.frame
            frostedView.isUserInteractionEnabled = false
            $0.insertSubview(frostedView, at: 0)
            $0.addTarget(self, action: #selector(setBingJiangLianFang), for: .touchUpInside)
            return $0
        }(SpringButton())
        
        let TunBingDongLuBtn: SpringButton = {
            $0.backgroundColor = UIColor(red:0.49, green:0.12, blue:0.11, alpha:0.66)
            $0.setImage(#imageLiteral(resourceName: "tunbingdonglu"), for: .normal)
            $0.imageView?.contentMode = .scaleAspectFit

            $0.layer.cornerRadius = 6
            $0.minimumScale = 0.92
            $0.frame = CGRect(x: 735, y: 400, width: 160, height: 80)
            $0.addTarget(self, action: #selector(setTunBingDongLu), for: .touchUpInside)
            return $0
        }(SpringButton())
        
        self.view?.addSubview(HengDaoLiMaBtn)
        self.view?.addSubview(BingLinCaoYingBtn)
        self.view?.addSubview(CengCengSheFangBtn)
        //self.view?.addSubview(BingJiangLianFangBtn)
        self.view?.addSubview(TunBingDongLuBtn)
         //For debugging
//        stepInBtn = SpringButton()
//        stepInBtn.backgroundColor = .green
//        stepInBtn.layer.cornerRadius = 6
//        stepInBtn.minimumScale = 0.92
//        stepInBtn.frame = CGRect(x: 800, y: 400, width: 200, height: 100)
//        stepInBtn.addTarget(self, action: #selector(automaticallyStepIn), for: .touchUpInside)
       
        //self.view?.addSubview(stepInBtn)
    }
    
    func setPosition() {
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
    
    func loadSprites() {
        let bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.position = CGPoint(x: (self.view?.frame.midX)!, y: (view?.frame.midY)!)
        bgNode.name = "background_node"
        
        bgNode.zPosition = 0
        
        addChild(bgNode)
        
        setPosition()
        
        for node in nodesArray {
            addChild(node)
        }
        
    }
    
    
    func refresh(results: [[(Int, Int)]]) {
        if stepTracker == RawAI.shared.backtrackSteps.count {
            return
        }

        for (index, node) in nodesArray.enumerated() {
            let dest = RawAI.shared.backtrackSteps[stepTracker][index]
            if Person.people[index].coordinate != dest {
                print("fuck")
                let action = SKAction.move(to: pointFrom(coordinate: dest), duration: 1)
                node.run(action) {
                    print("Moving")
                    Person.people[index].coordinate = dest
                    //node.position = self.pointFrom(coordinate: dest)
                    self.stepTracker += 1
                }
                continue
            } else {
                self.stepTracker += 1
                self.refresh(results: [])
            }
            
        }
    }
    
    func start() {
        findPath {
            //self.refresh()
        }
    }
    
    func findPath(and completion: () -> ()) {
        stepTracker = 0
        RawAI.shared.search {
            stateLayout in
            RawAI.shared.recursivelyDecode(layout: stateLayout) {
                
            }
            automaticallyStepIn()
        }
        
        //completion()
        
        
    }
    
    
    func automaticallyStepIn() {
        let timer = Timer.scheduledTimer(timeInterval: 0.9, target:self,selector: #selector(stepIn), userInfo:nil, repeats:true)
        timer.fire()
    }
    
    func stepIn() {
        if stepTracker == RawAI.shared.backtrackSteps.count || RawAI.shared.backtrackSteps.isEmpty {
            return
        }
        
        print(RawAI.shared.backtrackSteps.count)
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
    
    func refresh() {
        
        for (index, node) in nodesArray.enumerated() {
            let dest = pointFrom(coordinate: Person.people[index].coordinate)
            if node.position != dest {
                let move = SKAction.move(to: dest, duration: 0.7)
                node.run(move)
            }
        }
    }
    
    func pointFrom(coordinate: (x: Int, y: Int)) -> CGPoint {
        let convertedX = coordinate.x * 142 + 40
        let convertedY = 768 - (coordinate.y * 142 + 40)
        return CGPoint(x: convertedX, y: convertedY)
    }
    
    func pointFrom(person: Person) -> CGPoint {
        let convertedX = person.coordinate.x * 142 + 40
        let convertedY = 768 - (person.coordinate.y * 142 + 40)
        return CGPoint(x: convertedX, y: convertedY)
    }
    
    func setHengDaoLiMa() {
        
        Person.ZhaoYun.coordinate = (0, 0); Person.ZhaoYun.width = 1; Person.ZhaoYun.height = 2
        Person.CaoCao.coordinate = (1, 0); Person.CaoCao.width = 2; Person.CaoCao.height = 2;
        Person.HuangZhong.coordinate = (3, 0); Person.HuangZhong.width = 1; Person.HuangZhong.height = 2;
        Person.MaChao.coordinate = (0, 2); Person.MaChao.width = 1; Person.MaChao.height = 2;
        Person.GuanYu.coordinate = (1, 2); Person.GuanYu.width = 2; Person.GuanYu.height = 1;
        Person.Soldier1.coordinate = (0, 4); Person.Soldier1.width = 1; Person.Soldier1.height = 1;
        Person.Soldier2.coordinate = (1, 3); Person.Soldier2.width = 1; Person.Soldier2.height = 1;
        Person.ZhangFei.coordinate = (3, 2); Person.ZhangFei.width = 1; Person.ZhangFei.height = 2;
        Person.Soldier3.coordinate = (2, 3); Person.Soldier3.width = 1; Person.Soldier3.height = 1;
        Person.Soldier4.coordinate = (3, 4); Person.Soldier4.width = 1; Person.Soldier4.height = 1;
        
        setPosition()
    }
    
    func setBingLinCaoYing() {
        Person.ZhaoYun.coordinate = (3, 2); Person.ZhaoYun.width = 1; Person.ZhaoYun.height = 2
        Person.CaoCao.coordinate = (1, 0); Person.CaoCao.width = 2; Person.CaoCao.height = 2;
        Person.HuangZhong.coordinate = (1, 3); Person.HuangZhong.width = 1; Person.HuangZhong.height = 2;
        Person.MaChao.coordinate = (2, 3); Person.MaChao.width = 1; Person.MaChao.height = 2;
        Person.GuanYu.coordinate = (1, 2); Person.GuanYu.width = 2; Person.GuanYu.height = 1;
        Person.Soldier1.coordinate = (0, 0); Person.Soldier1.width = 1; Person.Soldier1.height = 1;
        Person.Soldier2.coordinate = (0, 2); Person.Soldier2.width = 1; Person.Soldier2.height = 1;
        Person.ZhangFei.coordinate = (0, 3); Person.ZhangFei.width = 1; Person.ZhangFei.height = 2;
        Person.Soldier3.coordinate = (3, 0); Person.Soldier3.width = 1; Person.Soldier3.height = 1;
        Person.Soldier4.coordinate = (3, 1); Person.Soldier4.width = 1; Person.Soldier4.height = 1;
        
        setPosition()
    }
    
    func setCengCengSheFang() {
        Person.ZhaoYun.coordinate = (3, 0); Person.ZhaoYun.width = 1;Person.ZhaoYun.height = 2
        Person.CaoCao.coordinate = (1, 1); Person.CaoCao.width = 2; Person.CaoCao.height = 2;
        Person.HuangZhong.coordinate = (0, 3); Person.HuangZhong.width = 1; Person.HuangZhong.height = 2;
        Person.MaChao.coordinate = (3, 2); Person.MaChao.width = 1; Person.MaChao.height = 2;
        Person.GuanYu.coordinate = (1, 3); Person.GuanYu.width = 2; Person.GuanYu.height = 1;
        Person.Soldier1.coordinate = (1, 0); Person.Soldier1.width = 1; Person.Soldier1.height = 1;
        Person.Soldier2.coordinate = (2, 0); Person.Soldier2.width = 1; Person.Soldier2.height = 1;
        Person.ZhangFei.coordinate = (0, 0); Person.ZhangFei.width = 1; Person.ZhangFei.height = 2;
        Person.Soldier3.coordinate = (0, 2); Person.Soldier3.width = 1; Person.Soldier3.height = 1;
        Person.Soldier4.coordinate = (3, 4); Person.Soldier4.width = 1; Person.Soldier4.height = 1;
        
        setPosition()
    }
    
    func setBingJiangLianFang() {
        Person.ZhaoYun.coordinate = (0, 1); Person.ZhaoYun.width = 1; Person.ZhaoYun.height = 2
        Person.CaoCao.coordinate = (1, 2); Person.CaoCao.width = 2; Person.CaoCao.height = 2;
        Person.HuangZhong.coordinate = (2, 0); Person.HuangZhong.width = 1; Person.HuangZhong.height = 2;
        Person.MaChao.coordinate = (3, 0); Person.MaChao.width = 1; Person.MaChao.height = 2;
        Person.GuanYu.coordinate = (0, 4); Person.GuanYu.width = 2; Person.GuanYu.height = 1;
        Person.Soldier1.coordinate = (0, 3); Person.Soldier1.width = 1; Person.Soldier1.height = 1;
        Person.Soldier2.coordinate = (3, 3); Person.Soldier2.width = 1; Person.Soldier2.height = 1;
        Person.ZhangFei.coordinate = (0, 0); Person.ZhangFei.width = 1; Person.ZhangFei.height = 2;
        Person.Soldier3.coordinate = (2, 4); Person.Soldier3.width = 1; Person.Soldier3.height = 1;
        Person.Soldier4.coordinate = (3, 4); Person.Soldier4.width = 1; Person.Soldier4.height = 1;
        
        setPosition()
    }
    
    func setTunBingDongLu() {
        Person.ZhaoYun.coordinate = (3, 0); Person.ZhaoYun.width = 1; Person.ZhaoYun.height = 2
        Person.CaoCao.coordinate = (0, 0); Person.CaoCao.width = 2; Person.CaoCao.height = 2;
        Person.HuangZhong.coordinate = (0, 3); Person.HuangZhong.width = 1; Person.HuangZhong.height = 2;
        Person.MaChao.coordinate = (1, 3); Person.MaChao.width = 1; Person.MaChao.height = 2;
        Person.GuanYu.coordinate = (0, 2); Person.GuanYu.width = 2; Person.GuanYu.height = 1;
        Person.Soldier1.coordinate = (2, 2); Person.Soldier1.width = 1; Person.Soldier1.height = 1;
        Person.Soldier2.coordinate = (3, 2); Person.Soldier2.width = 1; Person.Soldier2.height = 1;
        Person.ZhangFei.coordinate = (2, 0); Person.ZhangFei.width = 1; Person.ZhangFei.height = 2
        Person.Soldier3.coordinate = (2, 3); Person.Soldier3.width = 1; Person.Soldier3.height = 1;
        Person.Soldier4.coordinate = (3, 3); Person.Soldier4.width = 1; Person.Soldier4.height = 1;
        
        setPosition()
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
