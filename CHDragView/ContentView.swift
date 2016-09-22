///
//  VAHomeTaskView.swift
//  Vacances
//
//  Created by Chausson on 16/8/12.
//  Copyright © 2016年 Chausson. All rights reserved.
//

import UIKit



class ContentView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    //数据模型
    //接收任务的闭包
    var taskClosure:(()->())?
    
    private static let iconSize = CGSize(width: 180,height: 180)
    private static let textSize = CGSize(width: 200,height: 20)
    
    lazy private var icon : UIImageView = {
        let icon = UIImageView()
        icon.backgroundColor = UIColor.lightGrayColor()
        icon.layer.cornerRadius = iconSize.width/2
        icon.layer.masksToBounds = true
        return icon
    }()

    lazy var orderBtn:UIButton = {
        let btn = UIButton(type: .Custom)
        btn.backgroundColor = UIColor.grayColor()
        btn.addTarget(self, action: #selector(order), forControlEvents:.TouchUpInside)
        btn.setTitle("YES", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.boldSystemFontOfSize(21)
        return btn
    }()
    lazy var title:UILabel = {
        let btn = UILabel()
        btn.textColor = UIColor.whiteColor()
        btn.font = UIFont.systemFontOfSize(18)
        btn.text = "MUSEPUB 唱歌聊天"
        btn.textAlignment = .Center
        return btn
    }()
    lazy var content:UILabel = {
        let btn = UILabel()
        btn.textColor = UIColor.whiteColor()
        btn.font = UIFont.systemFontOfSize(18)
        btn.text = "7月23日 20:00"
        btn.textAlignment = .Center
        return btn
    }()
    lazy var price:UILabel = {
        let btn = UILabel()
        btn.textColor = UIColor.whiteColor()
        btn.font = UIFont.systemFontOfSize(18)
        btn.textAlignment = .Center
        btn.text = "外滩源\n北京东路99号"
        return btn
    }()
    func order() {
        if let closure = taskClosure {
            closure()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        backgroundColor = UIColor.lightGrayColor()
        layer.cornerRadius = 10
        layer.masksToBounds = true
        addSubview(orderBtn)
        addSubview(icon)
        addSubview(title)
        addSubview(content)
        addSubview(price)
    }
    override func layoutSubviews() {
        icon.frame = CGRect(origin: CGPoint(x:frame.size.width/2-ContentView.iconSize.width/2,y:10.0), size: ContentView.iconSize)
        title.frame = CGRect(origin: CGPoint(x:frame.size.width/2-ContentView.iconSize.width/2,y:CGRectGetMaxY(icon.frame)+10), size:ContentView.textSize)
        content.frame = CGRect(origin: CGPoint(x:frame.size.width/2-ContentView.iconSize.width/2,y:CGRectGetMaxY(title.frame)+10), size:ContentView.textSize)
        price.frame = CGRect(origin: CGPoint(x:frame.size.width/2-ContentView.iconSize.width/2,y:CGRectGetMaxY(content.frame)+10), size:ContentView.textSize)
        orderBtn.frame = CGRect(origin: CGPointMake(frame.size.width/2-40.0,CGRectGetMaxY(price.frame)+10), size: CGSize(width: 80, height: 80.0))
        orderBtn.layer.masksToBounds = true
        orderBtn.layer.cornerRadius = orderBtn.frame.size.height/2
    }
    func loadData(image:String){
        icon.image = UIImage(named: image)

        
    }
    
    
    
    
    
    
}