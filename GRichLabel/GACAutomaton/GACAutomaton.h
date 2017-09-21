//
//  GACAutomaton.h
//  GRichText
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GACResult.h"

@protocol GACObjectProtocol <NSObject>

@required

- (NSString *)getKeyString;

@end

@interface GACAutomaton : NSObject

- (void)insertString:(NSString*)aString;
- (void)insertStrings:(NSArray<NSString*>*)strings;

- (void)insertObjects:(NSArray<id<GACObjectProtocol>> *)objects;

- (NSArray<GACResult*>*)searchString:(NSString*)searchStr;

- (void)build;
- (void)destroy;

@end
