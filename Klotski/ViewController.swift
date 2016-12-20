//
//  ViewController.swift
//  Klotski
//
//  Created by Allen X on 11/16/16.
//  Copyright © 2016 allenx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(AI.shared.calculatePositionValues())
        AI.shared.assignNeighbours()
        for person in AI.people {
            print(person.name)
            if person.left != nil {
                for foo in person.left! {
                    print("\(person.name)的左边有\(foo.name)")
                }
            } else {
                print("\(person.name)的左边有 wall")
            }
            if person.right != nil {
                for foo in person.right! {
                    print("\(person.name)的右边有\(foo.name)")
                }
            } else {
                print("\(person.name)的右边有 wall")
            }
            if person.top != nil {
                for foo in person.top! {
                    print("\(person.name)的上边有\(foo.name)")
                }
            } else {
                print("\(person.name)的上边有 wall")
            }
            if person.bottom != nil {
                for foo in person.bottom! {
                    print("\(person.name)的下边有\(foo.name)")
                }
            } else {
                print("\(person.name)的下边有 wall")
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

