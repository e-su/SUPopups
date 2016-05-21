//
//  CALayer+Additions.m
//  SUPopupsViewDemo
//
//  Created by 苏俊海 on 16/5/19.
//  Copyright © 2016年 苏俊海. All rights reserved.
//

#import "CALayer+Additions.h"
#import <objc/runtime.h>

@implementation CALayer (Additions)

- (UIColor *)borderColorFromUIColor {
    return objc_getAssociatedObject(self, @selector(borderColorFromUIColor));
}

- (void)setBorderColorFromUIColor:(UIColor *)borderColorFromUIColor {
    objc_setAssociatedObject(self, @selector(borderColorFromUIColor), borderColorFromUIColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.borderColor = borderColorFromUIColor.CGColor;
}

@end
