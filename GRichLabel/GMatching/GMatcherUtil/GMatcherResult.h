//
//  GMatcherResult.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMatcherResult : NSObject

@property (nonatomic, assign) NSRange       range;
@property (nonatomic,   copy) NSString*     string;
@property (nonatomic, strong) id  info;

+ (instancetype)result:(NSString*)string location:(long)location userInfo:(id)info;

@end
