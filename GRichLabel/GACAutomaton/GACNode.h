//
//  GACNode.h
//  GRichText
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GACNode : NSObject

@property(nonatomic, strong) NSMutableDictionary<NSString*, GACNode*>*   next;
@property(nonatomic, strong) GACNode*                                    failed;
@property(nonatomic, copy) NSString*                                    storeString;
@property (nonatomic, strong) id                                        userInfo;

@end
