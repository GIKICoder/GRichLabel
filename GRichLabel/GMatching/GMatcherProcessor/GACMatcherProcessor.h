//
//  GACMatcherProcessor.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMatcherProcessor.h"
@interface GACMatcherProcessor : NSObject<IMatcherProcessor>

/**
 插入匹配字符串
 
 @param aString 匹配串
 */
- (void)insertString:(NSString*)aString;
- (void)insertStrings:(NSArray<NSString*>*)strings;


/**
 生成/销毁 匹配树
 */
- (void)build;
- (void)destroy;

/**
 查询匹配结果.
 
 @param searchStr 需要查询匹配结果的字符串
 @return 匹配结果集合
 */
- (NSArray<GMatcherResult*>*)searchString:(NSString*)searchStr;

@end
