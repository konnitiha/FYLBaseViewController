//
//  UIViewController+FYLAlpha.m
//  FYLBaseViewController
//
//  Created by FuYunLei on 2017/6/9.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "UIViewController+FYLAlpha.h"
#import <objc/runtime.h>
#import "UINavigationController+FYLAlpha.h"

@implementation UIViewController (FYLAlpha)

static char *AlphaKey="AlphaKey";
static char *TintColorKey="TintColorKey";

- (void)setNavBarTintColor:(UIColor *)navBarTintColor
{
    objc_setAssociatedObject(self, TintColorKey, navBarTintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.navigationController.navigationBar setTintColor:navBarTintColor];
}
- (UIColor *)navBarTintColor
{
    return objc_getAssociatedObject(self, TintColorKey);
}
-(void)setNavBarBgAlpha:(NSString *)navBarBgAlpha{

    objc_setAssociatedObject(self, AlphaKey, navBarBgAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self.navigationController setNavBarAlpha:[navBarBgAlpha floatValue]];
}

-(NSString *)navBarBgAlpha{
    return objc_getAssociatedObject(self, AlphaKey);
}

@end
