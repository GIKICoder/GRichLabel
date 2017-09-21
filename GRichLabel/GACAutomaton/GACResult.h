//
//  GACResult.h
//  GRichText
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GACResult : NSObject

@property (nonatomic, assign) NSRange       range;
@property (nonatomic, copy)   NSString*     string;
@property (nonatomic, strong) id  info;

+ (instancetype)result:(NSString*)string location:(long)location userInfo:(id)info;

@end
