# CHDragView
基于Swift实现的动画拖拽控件

# 如何使用
继承于控件CHDragView,实现它的协议,其中有一个协议是将需要展示的内容作为UIView返回
``` swift
 let dragView:CHDragView = CHDragView(frame: CGRect(x: 20, y: 100, width:UIScreen.mainScreen().bounds.size.width-40, height: 400))
 var content:ContentView = ContentView(frame:CGRectZero)

    func draggableContentView() -> UIView {
        content.loadData(images[Int(arc4random_uniform(3))])
        return content
    }
```
