//
//  GKMPMatcherProcessor.h
//  GMatchingKit
//
//  Created by GIKI on 2018/4/19.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMatcherProcessor.h"

@interface GKMPMatcherProcessor : NSObject<IMatcherProcessor>
- (void)insertString:(NSString*)aString;
- (NSArray*)searchString:(NSString*)searchStr;
@end
