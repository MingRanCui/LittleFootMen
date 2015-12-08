//
//  FMMemoModel.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "FMMemoModel.h"

@implementation FMMemoModel

- (id)initWithDataDic:(NSDictionary *)data {
    if (self = [super init]) {
        self.memoTitle = data[@"memoTitle"];
        self.memoTest = data[@"memoTest"];
        self.dateStr = data[@"dateStr"];
        self.cid = data[@"id"];
    }
    return self;
}

@end
