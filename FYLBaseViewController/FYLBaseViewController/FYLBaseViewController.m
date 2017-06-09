//
//  FYLBaseViewController.m
//  FYLBaseViewController
//
//  Created by FuYunLei on 2017/6/9.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "FYLBaseViewController.h"

@interface FYLBaseViewController ()

@end

@implementation FYLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navBarTintColor = [UIColor whiteColor];//按钮颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//标题颜色
    
    /*
     1.背景颜色
     2.背景图片
     二选一
     */
    //背景颜色
//    [self.navigationController.navigationBar setBarTintColor:[UIColor cyanColor]];
    
    //背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics:UIBarMetricsDefault];
    /*
     
     其他功能根据项目添加
     
     */
}

@end
