//
//  FMNewMemoViewController.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import <Masonry.h>
#import "UIViewExt.h"
#import "Parameter.h"
#import <FMDatabase.h>
#import "FMMemoModel.h"
#import "FMNewMemoViewController.h"

@interface FMNewMemoViewController ()<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) FMDatabase *db;

@property (strong, nonatomic) UIBarButtonItem *leftItem;  // 导航栏返回按钮
@property (strong, nonatomic) UIScrollView *scrBackView; // 滑动背景view
@property (strong, nonatomic) UIButton *backButton;   // 回收键盘的按钮
@property (strong, nonatomic) UILabel *titleLabel;   // 备忘标题
@property (strong, nonatomic) UITextField *titleText;  // 标题输入框
@property (strong, nonatomic) UILabel *testLabel;    // 提醒详情
@property (strong, nonatomic) UITextView *testView;  // 详情输入框
@property (strong, nonatomic) UIButton *saveButton;  // 保存按钮

@property (nonatomic, copy) NSString *currentTime; // 当前时间
@property (strong, nonatomic) NSMutableArray *dataArray; // 存放数据的数组

@end

@implementation FMNewMemoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"新建①条备忘卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:RGB(233, 133, 86, 1.0)}];
    self.navigationController.navigationBar.tintColor = RGB(233, 133, 86, 1.0);
    // 隐藏导航栏标题
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.size = CGSizeMake(44, 44);
    [backButton setImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    _leftItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    // 获取当前时间
    [self getCurrentDataTime];
    // 打开数据库
    [self openDataBase];
    // layout subViews
    [self layoutSubView];
    
//    NSLog(@"%@", self.cid);
    if (self.cid) {
        [self loadLocalData];
        [self addLocalData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrBackView];
    [self.scrBackView addSubview:self.backButton];
    [self.scrBackView addSubview:self.titleLabel];
    [self.scrBackView addSubview:self.titleText];
    [self.scrBackView addSubview:self.testLabel];
    [self.view addSubview:self.testView];
    [self.view addSubview:self.saveButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.db close];
}
#pragma mark - 获取当前时间
- (void)getCurrentDataTime {
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSLog(@"dateString:%@",dateString);
    self.currentTime = dateString;
}
#pragma mark - 本地数据库操作
- (void)openDataBase {
    // 获得数据库文件路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"LFM.sqlite"];
//    NSLog(@"%@", fileName);
    
    // 获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    // 打开数据库
    if ([db open]) {
//        NSLog(@"%@", @"数据库打开 OK");
    }
    
    // 创建表
    BOOL result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS memo (id integer PRIMARY KEY AUTOINCREMENT, title text NOT NULL, test text, time text NOT NULL);"];
    if (result) {
//        NSLog(@"%@",@"创建表成功");
    } else {
//        NSLog(@"%@",@"创建表失败");
    }
    
    self.db = db;
}

- (void)loadLocalData {
    _dataArray = [[NSMutableArray alloc] init];
    // 读取数据库中的数据
    FMResultSet *data = [self.db executeQuery:@"select * from memo where id=?;", self.cid];
    //    NSLog(@"%@", data);
    while ([data next]) {
        NSString *test  = [data stringForColumn:@"test"];
//        NSLog(@"%@", test);
        NSString *title = [data stringForColumn:@"title"];
//        NSLog(@"%@", title);
        NSString *time = [data stringForColumn:@"time"];
//        NSLog(@"%@", time);
        NSNumber *cid = [NSNumber numberWithInt:[data intForColumn:@"id"]];
        NSMutableDictionary *infoDict = [[NSMutableDictionary alloc]init];
        [infoDict setValue:title forKey:@"memoTitle"];
        [infoDict setValue:test forKey:@"memoTest"];
        [infoDict setValue:cid forKey:@"id"];
        [infoDict setValue:time forKey:@"dateStr"];
        //封装数据模型
        FMMemoModel *model = [[FMMemoModel alloc] initWithDataDic:infoDict];
        
        //将数据模型放入数组中
        [_dataArray addObject:model];
        
    }
}

// 插入数据
- (void)insertData {
    if (self.cid) {
        NSString *title = self.titleText.text;
        NSString *test = self.testView.text;
        [self.db executeUpdate:@"update memo set title=?,test=?,time=? where id=?;",title, test, self.currentTime, self.cid];
    } else {
        NSString *title = self.titleText.text;
        NSString *test = self.testView.text;
        [self.db executeUpdate:@"INSERT INTO memo (title, test, time) VALUES (?,?,?);",title, test, self.currentTime];
    }
}
// 加载数据
- (void)addLocalData {
    FMMemoModel *model = self.dataArray[0];
    self.titleText.text = model.memoTitle;
    self.testView.text = model.memoTest;
}

#pragma mark - clicked method

- (void)saveTheMemoDefault {
    NSString *str = self.titleText.text;
    if (str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        // 提示框
        UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"备忘卡的标题不能为空哦。。。" preferredStyle:UIAlertControllerStyleAlert];
        [warningAlert addAction:[UIAlertAction actionWithTitle:@"ok i see" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击按钮响应事件 do something here
        }]];
        // 显示 提示框
        [self presentViewController:warningAlert animated:YES completion:nil];
    } else {
        [self insertData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// 返回按钮 点击事件
- (void)backButtonItemClicked {
    NSString *str = self.titleText.text;
    FMMemoModel *model = [self.dataArray objectAtIndex:0];
    if (str == nil || str == NULL || [str isKindOfClass:[NSNull class]] || [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || ([self.titleText.text isEqualToString:model.memoTitle] && [self.testView.text isEqualToString:model.memoTest])) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UIAlertController *warningAlert = [UIAlertController alertControllerWithTitle:@"小提示" message:@"是否保存当前备忘卡" preferredStyle:UIAlertControllerStyleAlert];
        [warningAlert addAction:[UIAlertAction actionWithTitle:@"yes save it" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击按钮响应事件 do something here
            [self saveTheMemoDefault];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        [warningAlert addAction:[UIAlertAction actionWithTitle:@"no don't save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 点击按钮响应事件 do something here
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        
        // 显示 提示框
        [self presentViewController:warningAlert animated:YES completion:nil];
    }
}

- (void)hideKeyBoard {
    [self.titleText resignFirstResponder];
    [self.testView resignFirstResponder];
}

#pragma mark - textView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = - 100;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        self.view.frame = frame;
    }]; 
    return YES;
}

#pragma mark - layout SubView
- (void)layoutSubView {
    [_scrBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrBackView);
        make.width.equalTo(self.scrBackView.mas_width);
        make.height.equalTo(self.scrBackView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrBackView.mas_top).offset(20);
        make.left.equalTo(self.scrBackView.mas_left).offset(20);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    [_titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top);
        make.left.equalTo(self.titleLabel.mas_right);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
    }];
    
    [_testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.equalTo(self.scrBackView.mas_left).offset(20);
        make.width.equalTo(@240);
        make.height.equalTo(@30);
    }];
    
    [_testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testLabel.mas_bottom).offset(20);
        make.left.equalTo(self.scrBackView.mas_left).offset(20);
        make.right.equalTo(self.scrBackView.mas_right).offset(-20);
        make.height.equalTo(@300);
    }];
    
    [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-60);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.width.equalTo(@80);
        make.height.equalTo(@40);
    }];
}

#pragma mark - lazy loading

- (UIScrollView *)scrBackView {
    if (!_scrBackView) {
        _scrBackView = [[UIScrollView alloc] init];
        _scrBackView.contentSize = CGSizeMake(0, 520);
        _scrBackView.showsVerticalScrollIndicator = NO;
        _scrBackView.userInteractionEnabled = YES;
    }
    return _scrBackView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.backgroundColor = RGB(245, 245, 245, 1.0);
        [_backButton addTarget:self action:@selector(hideKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"标题";
        _titleLabel.textColor = RGB(75, 75, 73, 1.0);
    }
    return _titleLabel;
}

- (UITextField *)titleText {
    if (!_titleText) {
        _titleText = [[UITextField alloc] init];
        _titleText.delegate = self;
        _titleText.textColor = [UIColor grayColor];
        _titleText.borderStyle = UITextBorderStyleRoundedRect;
        _titleText.layer.borderColor = RGB(231, 202, 123, 1.0).CGColor;
        _titleText.layer.masksToBounds = YES;
        _titleText.layer.cornerRadius = 6.0;
    }
    return _titleText;
}

- (UILabel *)testLabel {
    if (!_testLabel) {
        _testLabel = [[UILabel alloc] init];
        _testLabel.text = @"小F请您写下您想备忘的事情";
        _testLabel.font = Font(15);
        _testLabel.textColor = [UIColor lightGrayColor];
    }
    return _testLabel;
}

- (UITextView *)testView {
    if (!_testView) {
        _testView = [[UITextView alloc] init];
        _testView.delegate = self;
        _testView.textColor = [UIColor grayColor];
        _testView.font = Font(14);
        _testView.layer.borderColor = RGB(231, 202, 123, 1.0).CGColor;
        _testView.layer.cornerRadius = 8.0;
    }
    return _testView;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = RGB(233, 133, 86, 1.0);
        _saveButton.layer.cornerRadius = 3.0;
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveTheMemoDefault) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
