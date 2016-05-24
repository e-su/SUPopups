//
//  ViewController.m
//  SUPopupsViewDemo
//
//  Created by 苏俊海 on 16/5/19.
//  Copyright © 2016年 sujunhai. All rights reserved.
//

#import "ViewController.h"
#import "SUPopupsView.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<SUPopupsViewDelegate>
{
    BOOL _isPopup;
    SEL _btnAction;
    UIButton *_btn;
}

@property (weak, nonatomic) IBOutlet UIView *leftView;

@end

@implementation ViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)didChangeStatusBarOrientation {
    if (_isPopup)
        [self performSelector:_btnAction withObject:_btn afterDelay:0];
}

- (void)additionWith:(SEL)sel :(UIButton *)btn :(SUPopupsView *)popup {
    _isPopup = YES;
    _btnAction = sel;
    _btn = btn;
    popup.delegate = self;
}

- (IBAction)topRightBtnAction:(UIButton *)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sender.frame) - 100, CGRectGetMaxY(sender.frame), 100, 120)];
    SUPopupsView *popup = [SUPopupsView popupsViewWithMenuView:view];
    popup.animation = SUPopupsViewAnimationScaleFade;
    popup.shadowEnabled = YES;
    [self.view.window addSubview:popup];
    [self additionWith:@selector(topRightBtnAction:) :sender :popup];
}

- (IBAction)topBtnAction:(UIButton *)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(sender.frame), kScreenWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    SUPopupsView *popup = [SUPopupsView popupsViewWithMenuView:view];
    popup.animation = SUPopupsViewAnimationTop;
    popup.backAlpha = 0.1;
    popup.backAlphaClip = YES;
    popup.backAlphaPosition = SUPopupsViewBackAlphaPositionBottom;
    [self.view.window addSubview:popup];
    [self additionWith:@selector(topBtnAction:) :sender :popup];
}

- (IBAction)leftBtnAction:(UIButton *)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_leftView.frame), CGRectGetMinY(_leftView.frame) + CGRectGetMaxY(sender.frame), CGRectGetWidth(sender.frame), 120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = sender.layer.borderColor;
    view.layer.borderWidth = 1;
    SUPopupsView *popup = [SUPopupsView popupsViewWithMenuView:view];
    popup.animation = SUPopupsViewAnimationTop;
    [self.view.window addSubview:popup];
    [self additionWith:@selector(leftBtnAction:) :sender :popup];
}

- (IBAction)middleBtnAction:(UIButton *)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 250) / 2, (kScreenHeight - 150) / 2, 250, 150)];
    view.layer.cornerRadius = 6;
    SUPopupsView *popup = [SUPopupsView popupsViewWithMenuView:view];
    popup.animation = SUPopupsViewAnimationMiddle;
    popup.backAlpha = 0.1;
    popup.shadowEnabled = YES;
    popup.shadowRadius = 6;
    popup.tapOutInsideEnabled = YES;
    [self.view.window addSubview:popup];
    [self additionWith:@selector(middleBtnAction:) :sender :popup];
}

- (IBAction)rightBtnAction:(UIButton *)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, kScreenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    SUPopupsView *popup = [SUPopupsView popupsViewWithMenuView:view];
    popup.animation = SUPopupsViewAnimationRight;
    popup.shadowEnabled = YES;
    popup.shadowRadius = 6;
    [self.view.window addSubview:popup];
    [self additionWith:@selector(rightBtnAction:) :sender :popup];
}

- (IBAction)bottomBtnAction:(UIButton *)sender {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 100, kScreenWidth, 100)];
    view.backgroundColor = [UIColor whiteColor];
    SUPopupsView *popup = [SUPopupsView popupsViewWithMenuView:view];
    popup.animation = SUPopupsViewAnimationBottom;
    popup.backAlpha = 0.1;
    [self.view.window addSubview:popup];
    [self additionWith:@selector(bottomBtnAction:) :sender :popup];
}

#pragma mark - SUPopupsViewDelegate
- (void)popupsViewDidRemoveFromSuperview:(SUPopupsView *)popupsView {
    if (!popupsView.abnormalRemove) {
        _isPopup = NO;
        _btnAction = nil;
        _btn = nil;
    }
}

@end
