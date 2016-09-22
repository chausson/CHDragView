# CHDragView
基于Swift2.0实现的动画拖拽控件

![image](https://raw.githubusercontent.com/chausson/CHDragView/master/CHDragView/DragView.gif)

# 如何使用
需要继承于控件CHDragView,实现它的协议方法draggableContentView
``` swift
 let dragView:CHDragView = CHDragView(frame: CGRect(x: 20, y: 100, width:UIScreen.mainScreen().bounds.size.width-40, height: 400))
 var content:ContentView = ContentView(frame:CGRectZero)

    func draggableContentView() -> UIView {
        content.loadData(images[Int(arc4random_uniform(3))])
        return content
    }
```
该协议方法返回一个UIView作为载体，CHDragView包装一个container作为这个载体的容器，进行显示，所有业务逻辑可以在这个协议中自定义。

