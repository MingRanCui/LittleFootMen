//
//  FMChangeViewController.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/10.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "Parameter.h"
#import "FMChangeViewController.h"

@interface FMChangeViewController ()

@end

@implementation FMChangeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = RGB(233, 133, 86, 1.0);
    // 隐藏导航栏标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
