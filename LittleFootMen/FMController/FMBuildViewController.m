//
//  FMBuildViewController.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import <Masonry.h>
#import <FMDatabase.h>
#import <JSONKit.h>
#import "UIViewExt.h"
#import "Parameter.h"
#import "FMBuildViewController.h"
#import "FMCalendarViewController.h"
#import "FMMemoTableViewCell.h"
#import "FMNewMemoViewController.h"
#import "FMMemoModel.h"

@interface FMBuildViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *leftItem;   // 导航栏左按钮
@property (strong, nonatomic) UIBarButtonItem *rightItem;  // 导航栏右按钮
@property (strong, nonatomic) UITableView *listTableView;  // 备忘卡列表
@property (strong, nonatomic) UIAlertController *deleteAleartView;
@property (strong, nonatomic) NSIndexPath *indexPathToBeDeleted; // 将要被删除的cell的indexPath

@property (strong, nonatomic) NSMutableArray *dataArray;   // 存放数据的数组

@property (strong, nonatomic) FMDatabase *db;

@end

@implementation FMBuildViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"我的备忘卡";
    // 导航栏 设置
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                                      NSForegroundColorAttributeName:RGB(233, 133, 86, 1.0)}];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage *rImg = [UIImage imageNamed:@"build_new"];
    rImg = [rImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _rightItem = [[UIBarButtonItem alloc] initWithImage:rImg style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemClicked)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    UIImage *lImg = [UIImage imageNamed:@"tab_clanear_select"];
    lImg = [lImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _leftItem = [[UIBarButtonItem alloc] initWithImage:lImg style:UIBarButtonItemStylePlain target:self action:@selector(leftBarItemClicked)];
    self.navigationItem.leftBarButtonItem = self.leftItem;
    // 打开数据库
    [self openDataBase];
    // 加载本地数据
    [self loadLocalData];
    // UI控件 尺寸布局
    [_listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.listTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor = [];
    [self.view addSubview:self.listTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.db close];
}

#pragma mark - 本地数据处理

- (void)openDataBase {
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"LFM.sqlite"];
    // 获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    
    // 打开数据库
    if ([db open]) {
//        NSLog(@"%@", @"数据库打开 OK");
    }
    
    self.db = db;
}

- (void)loadLocalData {
    _dataArray = [[NSMutableArray alloc] init];
    // 读取数据库中的数据
    FMResultSet *data = [self.db executeQuery:@"select * from memo;"];
//    NSLog(@"%@", data);
    while ([data next]) {
        NSString *test  = [data stringForColumn:@"test"];
        NSString *title = [data stringForColumn:@"title"];
        NSString *time = [data stringForColumn:@"time"];
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

#pragma mark - build a new memo
- (void)rightBarItemClicked {
    FMNewMemoViewController *newVC = [[FMNewMemoViewController alloc] init];
    [self.navigationController pushViewController:newVC animated:YES];
}

- (void)leftBarItemClicked {
    FMCalendarViewController *calendarVC = [[FMCalendarViewController alloc] init];
    [self.navigationController pushViewController:calendarVC animated:YES];
}

#pragma mark - tableView dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"cell";
    FMMemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [cell addTheValue:_dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMMemoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    FMNewMemoViewController *changeVC = [[FMNewMemoViewController alloc] init];
    changeVC.cid = model.cid;
    [self.navigationController pushViewController:changeVC animated:YES];
}

// Enable delete
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// Left delete 左划删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     * 此处需要写一些购物车数据列表删除的逻辑
     */
    self.indexPathToBeDeleted = indexPath;
    FMMemoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    // 提示框
    _deleteAleartView = [UIAlertController alertControllerWithTitle:@"Are You sure?" message:@"您确定删除这条备忘卡吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [_deleteAleartView addAction:[UIAlertAction actionWithTitle:@"No, I think again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [_deleteAleartView addAction:[UIAlertAction actionWithTitle:@"Yes, I'm sure!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 点击按钮响应事件
        [self.dataArray removeObjectAtIndex:[self.indexPathToBeDeleted row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:self.indexPathToBeDeleted] withRowAnimation:UITableViewRowAnimationTop];
        [self.db executeUpdate:@"delete from memo where id=?;", model.cid];
    }]];
    // 显示 提示框
    [self presentViewController:_deleteAleartView animated:YES completion:nil];
}

#pragma mark - lazy loading
- (UITableView *)listTableView {
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] init];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.rowHeight = 100;
        UIView *footView = [[UIView alloc] init];
        footView.size = CGSizeMake(self.view.frame.size.width, 1);
//        footView.backgroundColor = [UIColor grayColor];
        _listTableView.tableFooterView = footView;
        [_listTableView registerClass:[FMMemoTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _listTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
