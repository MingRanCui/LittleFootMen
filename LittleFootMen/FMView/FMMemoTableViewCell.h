//
//  FMMemoTableViewCell.h
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMMemoModel.h"

@interface FMMemoTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *memoTitle; // 备忘信息标题
@property (strong, nonatomic) UILabel *memoTest;  // 备忘信息简述
@property (strong, nonatomic) UILabel *dateLabel; // 填写备忘卡的日期时间

@property (strong, nonatomic) UIView *_deleteView; // add按钮的View

//赋值
-(void)addTheValue:(FMMemoModel *)Model;

@end
