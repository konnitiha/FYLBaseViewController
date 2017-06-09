//
//  UINavigationController+FYLAlpha.h
//  FYLBaseViewController
//
//  Created by FuYunLei on 2017/6/9.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (FYLAlpha)<UINavigationBarDelegate,UINavigationControllerDelegate>

- (void)setNavBarAlpha:(CGFloat)alpha;

@end
