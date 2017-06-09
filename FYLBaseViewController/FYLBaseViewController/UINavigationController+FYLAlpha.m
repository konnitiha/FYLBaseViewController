//
//  UINavigationController+FYLAlpha.m
//  FYLBaseViewController
//
//  Created by FuYunLei on 2017/6/9.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//



//原文 :http://www.jianshu.com/p/454b06590cf1

#import "UINavigationController+FYLAlpha.h"
#import "UIViewController+FYLAlpha.h"
#import <objc/runtime.h>


@implementation UINavigationController (FYLAlpha)


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.topViewController.preferredStatusBarStyle;
}

+ (void)initialize {

    if (self == [UINavigationController self]) {
        NSArray *needSwizzleSelectorArr = @[@"_updateInteractiveTransition:",@"popToViewController:animated:",@"popToRootViewControllerAnimated:"];
        
        for (NSString *selectorStr in needSwizzleSelectorArr) {
            NSString *str = [[NSString stringWithFormat:@"fyl_%@",selectorStr] stringByReplacingOccurrencesOfString:@"__" withString:@"_"];
            Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(selectorStr));
            Method swizzledMethod = class_getInstanceMethod([self class], NSSelectorFromString(str));
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

- (void)fyl_updateInteractiveTransition:(CGFloat)percentComplete {
    
    UIViewController *topViewController = self.topViewController;
    id<UIViewControllerTransitionCoordinator > coor = self.topViewController.transitionCoordinator;
    if (topViewController == nil || coor == nil) {
        [self fyl_updateInteractiveTransition:percentComplete];
        return;
    }
    
    //alpha
    UIViewController *fromViewController = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [coor viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGFloat fromAlpha = [fromViewController.navBarBgAlpha floatValue];
    CGFloat toAlpha = [toViewController.navBarBgAlpha floatValue];
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha)*percentComplete;
  
    [self setNavBarAlpha:newAlpha];
    
    // Tint Color
    UIColor *fromColor = fromViewController.navBarTintColor;
    UIColor *toColor = toViewController.navBarTintColor;
    UIColor *newColor = [self averageColor:fromColor toColor:toColor percent:percentComplete];
    self.navigationBar.tintColor = newColor;
    [self fyl_updateInteractiveTransition:percentComplete];
    
}

- (NSArray<UIViewController *> *)fyl_popToViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self setNavBarAlpha:[viewController.navBarBgAlpha floatValue]];
    self.navigationBar.tintColor = viewController.navBarTintColor;
    return [self fyl_popToViewController:viewController animated:animated];
}

- (NSArray<UIViewController *> *)fyl_popToRootViewControllerAnimated:(BOOL)animated{
     [self setNavBarAlpha:[self.viewControllers.firstObject.navBarBgAlpha floatValue]];
     self.navigationBar.tintColor = self.viewControllers.firstObject.navBarTintColor;
    return [self fyl_popToRootViewControllerAnimated:animated];
}

- (void)setNavBarAlpha:(CGFloat)alpha{

    UIView *barBackgroundView = self.navigationBar.subviews[0];
    
    UIView *shadowView = [barBackgroundView valueForKey:@"_shadowView"];
    if (shadowView != nil) {
        shadowView.alpha = alpha;
    }
    if (self.navigationBar.isTranslucent) {
        
        if ([[UIDevice currentDevice] systemVersion].floatValue>=10.0) {
            UIView *backgroundEffectView = [barBackgroundView valueForKey:@"_backgroundEffectView"];
            UIImage *image = [self.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
            if (backgroundEffectView != nil && image == nil) {
                backgroundEffectView.alpha = alpha;
                return;
            }
            
        }else
        {
            UIView *adaptiveBackdrop = [barBackgroundView valueForKey:@"_adaptiveBackdrop"];
            UIView *backdropEffectView = [barBackgroundView valueForKey:@"_backdropEffectView"];
            if (adaptiveBackdrop != nil && backdropEffectView != nil) {
                backdropEffectView.alpha = alpha;
                return;
            }
        }
        
    }
    barBackgroundView.alpha = alpha;
}
#pragma mark - private
- (UIColor *)averageColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent{
    
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat nowRed = fromRed + (toRed - fromRed) * percent;
    CGFloat nowGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat nowBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    
    return [UIColor colorWithRed:nowRed green:nowGreen blue:nowBlue alpha:nowAlpha];
    
}
#pragma mark - UINavigationBar Delegate
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    UIViewController *topVC = self.topViewController;
     id<UIViewControllerTransitionCoordinator > coor = topVC.transitionCoordinator;
    if (topVC != nil && coor != nil && coor.initiallyInteractive) {
        
        if ([[UIDevice currentDevice] systemVersion].floatValue>=10.0){
            
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                [self dealInteractionChanges:context];
            }];
         
        }else
        {
            [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                [self dealInteractionChanges:context];
            }];
        }
        return YES;
    }

    NSInteger itemCount = self.navigationBar.items.count;
    NSInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    
    [self popToViewController:popToVC animated:YES];
    return YES;
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    [self setNavBarAlpha:[self.topViewController.navBarBgAlpha floatValue]];
    self.navigationBar.tintColor = self.topViewController.navBarTintColor;
    return YES;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {
    
    if ([context isCancelled]) {// 自动取消了返回手势
        NSTimeInterval cancelDuration = [context transitionDuration] * (double)[context percentComplete];
        [UIView animateWithDuration:cancelDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:UITransitionContextFromViewControllerKey].navBarBgAlpha floatValue];
            
            [self setNavBarAlpha:nowAlpha];
        }];
    } else {// 自动完成了返回手势
        NSTimeInterval finishDuration = [context transitionDuration] * (double)(1 - [context percentComplete]);
        [UIView animateWithDuration:finishDuration animations:^{
            CGFloat nowAlpha = [[context viewControllerForKey:
                                 UITransitionContextToViewControllerKey].navBarBgAlpha floatValue];
            [self setNavBarAlpha:nowAlpha];
        }];
    }
}

@end
