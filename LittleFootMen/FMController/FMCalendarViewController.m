//
//  FMCalendarViewController.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import <Masonry.h>
#import "Parameter.h"
#import "FMCalendarViewController.h"
#import "WHUCalendarView.h"

@interface FMCalendarViewController ()

@property (strong, nonatomic) WHUCalendarView *calendarView;

@end

@implementation FMCalendarViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"我的行程历";
    [self layoutSubView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:[UIColor orangeColor]}];
    self.navigationController.navigationBar.tintColor = RGB(233, 133, 86, 1.0);
    // 隐藏导航栏标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //
    [self.view addSubview:self.calendarView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - layout subview
- (void)layoutSubView {
    
}

#pragma mark - lazy loading 
- (WHUCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[WHUCalendarView alloc] init];
        CGSize s=[_calendarView sizeThatFits:CGSizeMake(self.view.frame.size.width, FLT_MAX)];
        _calendarView.frame=CGRectMake(0, 64, s.width, s.height);
        _calendarView.onDateSelectBlk=^(NSDate* date){
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy年MM月dd"];
            NSString *dateString = [format stringFromDate:date];
            NSLog(@"%@",dateString);
        };
    }
    return _calendarView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
