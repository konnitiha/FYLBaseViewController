//
//  SecondViewController.m
//  FYLBaseViewController
//
//  Created by FuYunLei on 2017/6/9.
//  Copyright © 2017年 FuYunLei. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()<UIScrollViewDelegate>{
    BOOL statusBarShouldLight;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consHeight;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"渐变";
    self.navBarBgAlpha = @"0";
    statusBarShouldLight = YES;
    
    self.consHeight.constant = 1000;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (statusBarShouldLight) {
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}
- (IBAction)lastVc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rootVc:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat showNavBarOffsetY = 100;
    
    //navigationBar alpha
    if (contentOffsetY > showNavBarOffsetY) {
        CGFloat navAlpha = (contentOffsetY - showNavBarOffsetY) / 100;
        if (navAlpha > 1 ){
            navAlpha = 1;
        }
        self.navBarBgAlpha = [NSString stringWithFormat:@"%f",navAlpha];
        if (navAlpha > 0.8) {
            self.navBarTintColor = [UIColor whiteColor];//目前全部白色
            statusBarShouldLight = NO;
            
        }else{
            self.navBarTintColor = [UIColor whiteColor];
            statusBarShouldLight = YES;
        }
    }else{
        self.navBarBgAlpha = 0;
        self.navBarTintColor = [UIColor whiteColor];
        statusBarShouldLight = YES;
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

@end
