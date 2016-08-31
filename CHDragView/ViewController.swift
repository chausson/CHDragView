//
//  ViewController.swift
//  CHDragView
//
//  Created by Chausson on 16/8/25.
//  Copyright © 2016年 Chausson. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CHDragViewProtocol {
    let dragView:CHDragView = CHDragView(frame: CGRect(x: 20, y: 100, width:UIScreen.mainScreen().bounds.size.width-40, height: 400))
    let images = ["prettyGirl","prettyGirl2","prettyGirl3"]
    var index :NSInteger = 0
    var content:ContentView = ContentView(frame:CGRectZero)
    override func viewDidLoad() {
        super.viewDidLoad()
        content.frame = dragView.bounds
        view.backgroundColor = UIColor.whiteColor()
        dragView.delegate = self
        view.addSubview(dragView)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func didFinishDrag(dragView: CHDragView,  direction: CHDragViewDerection) {
        print(direction)
    }
    func didRemoveDragView(dragView: CHDragView,  direction: CHDragViewDerection) {
        index += 1
        print(direction)
    }
    func willBeganDraggingView(dragView:CHDragView){
        
    }
    func draggableContentView() -> UIView {
        content.loadData(images[Int(arc4random_uniform(3))])
        return content
    }

}

