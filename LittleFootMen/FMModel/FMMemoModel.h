//
//  FMMemoModel.h
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "FMBaseModel.h"

@interface FMMemoModel : FMBaseModel

@property (nonatomic) NSString *memoTitle;  // 备忘信息标题
@property (nonatomic) NSString *memoTest;   // 备忘信息详细
@property (nonatomic) NSString *dateStr;    // 写备忘卡的时间
@property (nonatomic) NSNumber *cid;  // model的id

@end
