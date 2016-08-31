//
//  CHDragView.swift
//  CHDragView
//
//  Created by Chausson on 16/8/25.
//  Copyright © 2016年 Chausson. All rights reserved.
//

import UIKit
public enum CHDragViewDerection :Int {
    case Default
    case Left
    case Right
}
public protocol CHDragViewProtocol {
    func willBeganDraggingView(dragView:CHDragView)
    func didFinishDrag(dragView:CHDragView,direction:CHDragViewDerection)
    func didRemoveDragView(dragView:CHDragView,direction:CHDragViewDerection)
    func draggableContentView()-> UIView
}
public struct DragPostion {
    var originalCenter: CGPoint
    var originalTransform: CGAffineTransform
    var originalFrame: CGRect
    init(center:CGPoint,transform:CGAffineTransform,frame:CGRect){
        originalTransform = transform
        originalCenter = center
        originalFrame = frame
    }
}

let kBoundaryRatio:Float = 0.5
let kFirstCardScale:Float  = 1.48
let kSecondCardScale:Float = 0.52
public class CHDragView: UIView {
    private var isMoving :Bool = false
    private var datas:[AnyObject]!
    private var currentIndex:NSInteger!
    private var postionInfo:DragPostion!
    private var contentView:UIView?
    public  var radious :CGFloat!
    public  var direction :CHDragViewDerection!
    public  var delegate:CHDragViewProtocol?

    public func loadData(data:AnyObject){
        
    }
    public func dragView(direction:CHDragViewDerection){
        switch direction{
        case .Right: break
        case .Left: break
        default:break
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        defaultConfig()
        
    }
    override public func didMoveToSuperview() {
        postionInfo = DragPostion(center: center, transform: transform,frame:frame)
        contentView = delegate?.draggableContentView()
        if   contentView != nil{
            addSubview(contentView!)
            contentView!.layoutIfNeeded()
        }
    }
    private func defaultConfig(){
        backgroundColor = UIColor.clearColor()
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }
    func handlePanGesture(gesture:UIPanGestureRecognizer){
        switch gesture.state {
        case .Began:
            if (delegate != nil) {
                delegate?.willBeganDraggingView(self)
            }
           return
        case .Changed:
            let dragView:CHDragView = gesture.view as! CHDragView
            let point = gesture.translationInView(self)
            let movedPoint = CGPoint(x: (gesture.view?.center.x)!+point.x, y: (gesture.view?.center.y)!+point.y)
            dragView.center = movedPoint
            let transformY = (dragView.center.x - postionInfo.originalCenter.x) / postionInfo.originalCenter.x * (CGFloat(M_PI_4) / 12)
            dragView.transform = CGAffineTransformRotate(postionInfo.originalTransform, transformY)
            gesture.setTranslation(CGPointZero, inView: self)
            let widthOffset:Float = Float((dragView.center.x - postionInfo.originalCenter.x) / postionInfo.originalCenter.x)
           // print("width = \(widthOffset) transformY= \(transformY)")
            if widthOffset > 0 {
                direction = .Right
            }else if widthOffset == 0{
                direction = .Default
            }else{
                direction = .Left
            }
            judgeMovingState(widthOffset)
        //    let heightRatio = (dragView.center.y - center.y) / center.y;
        case .Ended ,.Cancelled:
            let widthRatio = (gesture.view!.center.x - postionInfo.originalCenter.x) / postionInfo.originalCenter.x;
            let moveWidth  = (gesture.view!.center.x  - postionInfo.originalCenter.x);
            let moveHeight = (gesture.view!.center.y - postionInfo.originalCenter.y);
            
            finshPanGesture(gesture.view!, scale: moveWidth/moveHeight, disappear: fabs(widthRatio) > CGFloat(kBoundaryRatio))
           // [self finishedPanGesture:gesture.view direction:self.direction scale:(moveWidth / moveHeight) disappear:fabs(widthRatio) > kBoundaryRatio];
        default:
            "default"
        }
    }
    func judgeMovingState(widthOffset:Float)  {
        if (!isMoving) {
            isMoving = true;

        } else {
            movingVisibleCards(widthOffset)
        }
    }
    func movingVisibleCards( widthOffset:Float) {

        var alphaOffset = 1.0-widthOffset
        if alphaOffset > 1.0 {
            alphaOffset -= 1.0
            alphaOffset = 1 - alphaOffset
        }

    //    print("alpha = \(alphaOffset)")
        UIView.animateWithDuration(0.45, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options:[ .CurveEaseInOut,.AllowUserInteraction], animations: {
            self.alpha = CGFloat(alphaOffset)
        
        }) { finish in
            
            
        }
        //        背景放大动画
        //        let offset = fabs(widthOffset) >= kBoundaryRatio ? kBoundaryRatio : fabs(widthOffset);
        //
        //        let sPoor = kFirstCardScale - kSecondCardScale
        //        let tPoor = sPoor / (kBoundaryRatio / offset)
        //        let yPoor =  (kBoundaryRatio / offset)
        //
        //        let scale = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(tPoor  + kSecondCardScale) , CGFloat(tPoor + kSecondCardScale));
        //        let translate = CGAffineTransformTranslate(scale, 0, CGFloat(-yPoor));
//        if   contentView != nil{
//            contentView!.transform = translate
//        }

    }
    func finshPanGesture(content:UIView,scale:CGFloat,disappear:Bool) {
        if (delegate != nil) {
            delegate?.didFinishDrag(self, direction: direction)
        }
        if !disappear {
            isMoving = false
            resetContentView()
        }else{
            if (delegate != nil) {
                delegate?.didRemoveDragView(self, direction: direction)
            }
            let flag =  CGFloat(direction == .Some(.Left) ? -1 :2)
            let width = UIScreen.mainScreen().bounds.size.width
            UIView.animateWithDuration(0.5, delay: 0.0, options: [.CurveLinear, .AllowUserInteraction], animations: {
                content.center = CGPointMake(width*flag, width * flag / scale + self.postionInfo.originalCenter.y)
                self.alpha = 0
                }, completion: { finished in
                    self.showNextPage()
            })

        }
    }
    func resetContentView()  {

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options:[ .CurveEaseInOut,.AllowUserInteraction], animations: {
            self.alpha = 1
            self.transform = CGAffineTransformRotate(self.postionInfo.originalTransform, 0)
            self.frame = self.postionInfo.originalFrame
            self.center = self.postionInfo.originalCenter
            }) { finish in
                
                
        }
    }
    func showNextPage() {
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(kSecondCardScale), CGFloat(kSecondCardScale));
        self.center = postionInfo.originalCenter
        for  subview in self.subviews{
            subview.removeFromSuperview()
        }
        contentView = delegate?.draggableContentView()
        if   contentView != nil{
            addSubview(contentView!)
            contentView!.layoutIfNeeded()
        }
  
        UIView.animateWithDuration(0.45, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options:[ .CurveEaseInOut,.AllowUserInteraction], animations: {
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, CGFloat(kFirstCardScale), CGFloat(kFirstCardScale));
            self.transform = CGAffineTransformRotate(self.postionInfo.originalTransform, 0)
            self.alpha = 1

        }) { finish in


        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
