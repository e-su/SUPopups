//
//  SUPopupsView.h
//  弹出菜单 v1.1
//
//  Created by 苏俊海 on 16/2/25.
//  Copyright © 2016年 sujunhai. All rights reserved.
//

/*
 简介：
 只要给我传入一个view，我便给你一个popupsView
 
 使用：
 1.把SUPopups文件夹拖到项目中
 2.#import "SUPopupsView.h"
 3.创建一个view（需要设置相对于全屏的frame）
 4.用便利构造器：+popupsViewWithMenuView:初始化实例得到popupsView，menuView为第3步的view
 5.设置属性
 6.[self.view.window addSubview:popupsView];（这句要放在设置属性之后）
 */

#import <UIKit/UIKit.h>
@class SUPopupsView;

typedef NS_ENUM(NSInteger, SUPopupsViewAnimation) {
    SUPopupsViewAnimationFade,
    SUPopupsViewAnimationScaleFade,
    SUPopupsViewAnimationMiddle,
    SUPopupsViewAnimationRight,           // slide in from right (or out to right)
    SUPopupsViewAnimationLeft,
    SUPopupsViewAnimationTop,
    SUPopupsViewAnimationBottom,
    SUPopupsViewAnimationNone
};

typedef NS_ENUM(NSInteger, SUPopupsViewBackAlphaPosition) {
    SUPopupsViewBackAlphaPositionRight,
    SUPopupsViewBackAlphaPositionLeft,
    SUPopupsViewBackAlphaPositionTop,
    SUPopupsViewBackAlphaPositionBottom,
    SUPopupsViewBackAlphaPositionNone
};

@protocol SUPopupsViewDelegate <NSObject>

/** 从父视图移除后 */
- (void)popupsViewDidRemoveFromSuperview:(SUPopupsView *)popupsView;

@end

@interface SUPopupsView : UIView

@property (nonatomic, weak) id<SUPopupsViewDelegate>delegate;

/** 动画样式（默认SUPopupsViewAnimationNone） */
@property (nonatomic, assign) SUPopupsViewAnimation animation;
/** 动画时间（默认0.3） */
@property (nonatomic, assign) NSTimeInterval duration;

/** 背景不透明度（默认0） */
@property (nonatomic, assign) CGFloat backAlpha;
/** 根据backAlphaPosition，只有部分背景不透明度有效（默认NO） */
@property (nonatomic, assign) BOOL backAlphaClip;
/** 背景不透明度相对位置（默认SUPopupsViewBackAlphaPositionNone） */
@property (nonatomic, assign) SUPopupsViewBackAlphaPosition backAlphaPosition;

/** 弹窗是否有阴影（默认NO） */
@property (nonatomic, assign) BOOL shadowEnabled;
/** 阴影颜色（默认black） */
@property (nonatomic, strong) UIColor *shadowColor;
/** 阴影不透明度（默认0.5） */
@property (nonatomic, assign) CGFloat shadowOpacity;
/** 阴影半径（默认3） */
@property (nonatomic, assign) CGFloat shadowRadius;

/** 能否通过轻拍弹窗之外的地方退出弹窗（默认YES） */
@property (nonatomic, assign) BOOL tapOutEnabled;
/** 能否通过轻拍弹窗之内的地方退出弹窗（默认NO） */
@property (nonatomic, assign) BOOL tapOutInsideEnabled;

/** 屏幕旋转时从父视图的非常规移除（默认NO） */
@property (nonatomic, assign) BOOL abnormalRemove;

/**
 @param menuView 你想要弹出的菜单视图
 @result 把SUPopupsView的实例添加到self.view.window上
 */
+ (instancetype)popupsViewWithMenuView:(UIView *)menuView;

@end
