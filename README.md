# SUPopups
简介：<br>
只要给我传入一个view，我便给你一个popupsView<br>
<br>
使用：<br>
1.把SUPopups文件夹拖到项目中<br>
2.#import "SUPopupsView.h"<br>
3.创建一个view（需要设置相对于全屏的frame）<br>
4.用便利构造器：+popupsViewWithMenuView:初始化实例得到popupsView，menuView为第3步的view<br>
5.设置属性<br>
6.[self.view.window addSubview:popupsView];（这句要放在设置属性之后）<br>
<br>
运行效果：<br>
![image](https://github.com/s373655682/SUPopups/raw/master/screenshot.gif)
