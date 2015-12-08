//
//  FirstViewController.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "FirstViewController.h"
#import "FMBuildViewController.h"
#import "Parameter.h"

@interface FirstViewController () {
    UIImageView *_imageView2;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGuideScrollView];
}

- (void)addGuideScrollView {
    UIScrollView *guideScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    guideScrollView.pagingEnabled = YES;
    guideScrollView.showsHorizontalScrollIndicator = NO;
    guideScrollView.contentSize = CGSizeMake((MSSize_Width), MSSize_Height);
    [self.view addSubview:guideScrollView];
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MSSize_Width, MSSize_Height)];
    imageView1.image = [UIImage imageNamed:@"Thank_You.jpg"];
    [guideScrollView addSubview:imageView1];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake((MSSize_Width - 110), (MSSize_Height-kTB_Height), 104, 44);
    button.titleLabel.font = Font(24);
    [button setTitle:@"Let's Go!" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction {
    [UIView animateWithDuration:2 animations:^{
        _imageView2.alpha = 0;
    } completion:^(BOOL finished) {
        FMBuildViewController *mainTabBarController = [[FMBuildViewController alloc] init];
        UINavigationController *FMNavi = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
        [UIApplication sharedApplication].keyWindow.rootViewController = FMNavi;
    }];
}

- (void)dealloc {
    NSLog(@"FirstViewController已经销毁");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
