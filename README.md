# SUPopups
简介：
只要给我传入一个view，我便给你一个popupsView

使用：
1.把SUPopups文件夹拖到项目中
2.#import "SUPopupsView.h"
3.创建一个view（需要设置相对于全屏的frame）
4.用便利构造器：+popupsViewWithMenuView:初始化实例得到popupsView，menuView为第3步的view
5.设置属性
6.[self.view.window addSubview:popupsView];（这句要放在设置属性之后）

![image](https://github.com/s373655682/SUPopups/raw/master/screenshot.gif)