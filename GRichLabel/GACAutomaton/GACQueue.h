//
//  GACQueue.h
//  GRichLabel
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GACQueue : NSObject

- (void)addQueue:(id)object;
- (id)getQueue;

- (BOOL)isEmpty;
- (void)clean;

@end
