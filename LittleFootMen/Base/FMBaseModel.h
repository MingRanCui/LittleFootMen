//
//  FMBaseModel.h
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/7.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMBaseModel : NSObject

- (id)initWithDataDic:(NSDictionary *)data;
- (NSDictionary *)attributeMapDictionary;
- (void)setAttributes:(NSDictionary *)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData *)getArchivedData;

- (NSString *)cleanString:(NSString *)str; //清除\n和\r的字符串

@end
