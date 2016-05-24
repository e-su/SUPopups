//
//  SUPopupsView.m
//  弹出菜单 v1.2
//
//  Created by 苏俊海 on 16/2/25.
//  Copyright © 2016年 sujunhai. All rights reserved.
//

#import "SUPopupsView.h"

// 屏幕宽高
#define SUScreenWidth [UIScreen mainScreen].bounds.size.width
#define SUScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SUPopupsView ()<UIGestureRecognizerDelegate>
{
    UIView *_menuView;
    CGRect _clipFrame;
    BOOL _isIn;
    UIView *_shadowClipView;
    UIView *_shadowConstantView;
    UIView *_shadowView;
    CGFloat _shadowRadius2;
    CGRect _shadowClipFrame;
    CGRect _shadowConstantFrame;
    CGFloat _shadowClipDuration;
    CGFloat _menuAlpha;
    BOOL _isPopup;
    BOOL _isFirst;
    UIView *_backAlphaView;
    CGFloat _abnormalDuration;
}
@end

@implementation SUPopupsView

// 便利构造器
+ (instancetype)popupsViewWithMenuView:(UIView *)menuView {
    SUPopupsView *popupsView = [[SUPopupsView alloc] initWithMenuView:menuView];
    return popupsView;
}

- (instancetype)initWithMenuView:(UIView *)menuView {
    self = [super init];
    if (self) {
        // 默认设置
        _menuView = menuView;
        _clipFrame = menuView.frame;
        _menuView.frame = menuView.bounds;
        _animation = SUPopupsViewAnimationNone;
        _duration = 0.3;
        _isIn = YES;
        _backAlpha = 0;
        _backAlphaClip = NO;
        _backAlphaPosition = SUPopupsViewBackAlphaPositionNone;
        _shadowEnabled = NO;
        _shadowColor = [UIColor blackColor];
        _shadowOpacity = 0.5;
        _shadowRadius = 3;
        _tapOutEnabled = YES;
        _tapOutInsideEnabled = NO;
        _isFirst = YES;
        _abnormalRemove = NO;
    }
    return self;
}

// 添加到父视图时会走一次，从父视图移除时会走一次
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (_isIn) {
        _isIn = NO;
        _isPopup = YES;
        if (_abnormalRemove) {
            _abnormalRemove = NO;
            _duration = _abnormalDuration;
        }
        
        if (_isFirst) {
            _isFirst = NO;
            _shadowRadius2 = _shadowRadius * 2;
            _shadowClipDuration = _duration / 3;
            _menuAlpha = _menuView.alpha;
            self.frame = self.superview.bounds;
            
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
            tapGR.delegate = self;
            [self addGestureRecognizer:tapGR];
            
            // 创建一个裁剪后的背景层
            if (_backAlphaClip && _backAlphaPosition != SUPopupsViewBackAlphaPositionNone) {
                [self backAlphaView];
            }
            
            if (_shadowEnabled) {
                // 阴影遮罩层
                _shadowClipFrame = CGRectMake(_clipFrame.origin.x - _shadowRadius2, _clipFrame.origin.y - _shadowRadius2, _clipFrame.size.width + _shadowRadius2 * 2, _clipFrame.size.height + _shadowRadius2 * 2);
                _shadowClipView = [[UIView alloc] init];
                _shadowClipView.clipsToBounds = YES;
                [self addSubview:_shadowClipView];
                
                // 阴影固定层（模拟_menuView所在的环境，只是为了在进行动画时简化相对位置的计算）
                _shadowConstantFrame = CGRectMake(_shadowRadius2, _shadowRadius2, _clipFrame.size.width, _clipFrame.size.height);
                _shadowConstantView = [[UIView alloc] initWithFrame:_shadowConstantFrame];
                [_shadowClipView addSubview:_shadowConstantView];
                
                // 阴影层
                _shadowView = [[UIView alloc] initWithFrame:_menuView.frame];
                if (_menuView.backgroundColor) {
                    _shadowView.backgroundColor = _menuView.backgroundColor;
                } else
                    _shadowView.backgroundColor = [UIColor whiteColor];
                _shadowView.layer.cornerRadius = _menuView.layer.cornerRadius;
                [self setShadowForView:_shadowView];
                [_shadowConstantView addSubview:_shadowView];
            }
            
            // clipView相当于遮罩层，被遮罩层与遮罩层重叠的地方会显示出来，不重叠的地方为透明
            UIView *clipView = [[UIView alloc] initWithFrame:_clipFrame];
            clipView.clipsToBounds = YES;
            [self addSubview:clipView];
            [clipView addSubview:_menuView];
            
            if (_animation == SUPopupsViewAnimationMiddle) {
                _shadowClipView.clipsToBounds = NO;
                clipView.clipsToBounds = NO;
            }
        }
        
        if (_shadowEnabled) {
            [self switchShadowClipAnimation];
        }
        [self switchAnimation];
        [self addToSuperview];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarOrientation) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    } else {
        _isIn = YES;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
}

// 屏幕将旋转
- (void)willChangeStatusBarOrientation {
    _abnormalRemove = YES;
    _abnormalDuration = _duration;
    _duration = 0;
    [self removeFromSuperview];
}

- (void)tapGRAction {
    if (_tapOutEnabled) {
        [self removeFromSuperview];
    }
}

- (void)addToSuperview {
    [UIView animateWithDuration:_duration animations:^{
        _menuView.transform = CGAffineTransformMakeScale(1, 1);
        _menuView.transform = CGAffineTransformMakeTranslation(0, 0);
        _menuView.alpha = _menuAlpha;
        UIColor *color = [UIColor colorWithWhite:0 alpha:_backAlpha];
        if (_backAlphaView) {
            color = [UIColor colorWithWhite:0 alpha:0];
            _backAlphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:_backAlpha];
        }
        self.backgroundColor = color;
        _shadowView.transform = _menuView.transform;
        _shadowView.alpha = _menuView.alpha;
        _shadowConstantView.alpha = _menuView.alpha;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:_shadowClipDuration animations:^{
            _shadowClipView.frame = _shadowClipFrame;
            _shadowConstantView.frame = _shadowConstantFrame;
        }];
    }];
}

- (void)removeFromSuperview {
    [UIView animateWithDuration:_shadowClipDuration animations:^{
        [self switchShadowClipAnimation];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:_duration animations:^{
            [self switchAnimation];
        } completion:^(BOOL finished) {
            [super removeFromSuperview];
            [self.delegate popupsViewDidRemoveFromSuperview:self];
            _menuView.alpha = _menuAlpha;
        }];
    }];
}

- (void)switchAnimation {
    switch (_animation) {
        case SUPopupsViewAnimationFade:
            _menuView.alpha = 0;
            break;
        case SUPopupsViewAnimationScaleFade:
            // 缩放是以锚点为中心进行的
            [self setAnchorPoint:CGPointMake(0.5, 0) forView:_menuView];
            // 通过改变frame所进行的动画，_menuView内的控件不会随着_menuView的缩放而缩放，只会在动画开始时瞬间变为最后的frame，而通过改变transform所进行的动画，_menuView内的控件会随着_menuView的缩放而缩放
            _menuView.transform = CGAffineTransformMakeScale(0.9, 0.9);
            _menuView.alpha = 0;
            break;
        case SUPopupsViewAnimationMiddle:
            if (_isPopup) {
                _isPopup = NO;
                _menuView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            }
            _menuView.alpha = 0;
            break;
        case SUPopupsViewAnimationRight:
            _menuView.transform = CGAffineTransformMakeTranslation(_clipFrame.size.width, 0);
            break;
        case SUPopupsViewAnimationLeft:
            _menuView.transform = CGAffineTransformMakeTranslation(-_clipFrame.size.width, 0);
            break;
        case SUPopupsViewAnimationTop:
            _menuView.transform = CGAffineTransformMakeTranslation(0, -_clipFrame.size.height);
            break;
        case SUPopupsViewAnimationBottom:
            _menuView.transform = CGAffineTransformMakeTranslation(0, _clipFrame.size.height);
            break;
        case SUPopupsViewAnimationNone:
            break;
    }
    
    _shadowView.transform = _menuView.transform;
    _shadowView.alpha = _menuView.alpha;
    _shadowConstantView.alpha = _menuView.alpha;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    _backAlphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
}

// 设置_shadowClipView的动画
- (void)switchShadowClipAnimation {
    CGRect shadowClipRect = _shadowClipFrame;
    CGRect shadowConstantRect = _shadowConstantFrame;
    
    switch (_animation) {
        case SUPopupsViewAnimationFade:
            break;
        case SUPopupsViewAnimationScaleFade:
            break;
        case SUPopupsViewAnimationMiddle:
            break;
        case SUPopupsViewAnimationRight:
            shadowClipRect.size.width -= _shadowRadius2;
            break;
        case SUPopupsViewAnimationLeft:
            shadowClipRect.origin.x += _shadowRadius2;
            shadowClipRect.size.width -= _shadowRadius2;
            shadowConstantRect.origin.x = 0;
            break;
        case SUPopupsViewAnimationTop:
            shadowClipRect.origin.y += _shadowRadius2;
            shadowClipRect.size.height -= _shadowRadius2;
            shadowConstantRect.origin.y = 0;
            break;
        case SUPopupsViewAnimationBottom:
            shadowClipRect.size.height -= _shadowRadius2;
            break;
        case SUPopupsViewAnimationNone:
            break;
    }
    
    _shadowClipView.frame = shadowClipRect;
    _shadowConstantView.frame = shadowConstantRect;
}

// 创建一个裁剪后的背景层
- (void)backAlphaView {
    CGRect rect = CGRectZero;
    
    switch (_backAlphaPosition) {
        case SUPopupsViewBackAlphaPositionRight:
            rect = CGRectMake(CGRectGetMinX(_clipFrame), CGRectGetMinY(_clipFrame), SUScreenWidth - CGRectGetMinX(_clipFrame), CGRectGetHeight(_clipFrame));
            break;
        case SUPopupsViewBackAlphaPositionLeft:
            rect = CGRectMake(0, CGRectGetMinY(_clipFrame), CGRectGetMaxX(_clipFrame), CGRectGetHeight(_clipFrame));
            break;
        case SUPopupsViewBackAlphaPositionTop:
            rect = CGRectMake(CGRectGetMinX(_clipFrame), 0, CGRectGetWidth(_clipFrame), CGRectGetMaxY(_clipFrame));
            break;
        case SUPopupsViewBackAlphaPositionBottom:
            rect = CGRectMake(CGRectGetMinX(_clipFrame), CGRectGetMinY(_clipFrame), CGRectGetWidth(_clipFrame), SUScreenHeight - CGRectGetMinY(_clipFrame));
            break;
        case SUPopupsViewBackAlphaPositionNone:
            break;
    }
    
    _backAlphaView = [[UIView alloc] initWithFrame:rect];
    [self addSubview:_backAlphaView];
}

// 设置阴影
- (void)setShadowForView:(UIView *)view {
    CALayer *layer = view.layer;
    layer.shadowColor = _shadowColor.CGColor;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = _shadowOpacity;
    layer.shadowRadius = _shadowRadius;
}

// 如果改变一个图层的锚点，这个图层会发生位移，于是要写一个方法来把位移修复回来
- (void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view {
    CGPoint oldPoint = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newPoint = view.frame.origin;
    // 计算变化量
    CGPoint transform;
    transform.x = newPoint.x - oldPoint.x;
    transform.y = newPoint.y - oldPoint.y;
    // 把位移修复回来
    view.center = CGPointMake(view.center.x - transform.x, view.center.y - transform.y);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 使手势在_menuView的范围中无效
    if (!_tapOutInsideEnabled) {
        if (CGRectContainsPoint(_clipFrame, [gestureRecognizer locationInView:gestureRecognizer.view])) {
            return NO;
        }
    }
    return YES;
}

@end
