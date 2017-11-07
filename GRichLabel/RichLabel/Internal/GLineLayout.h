//
//  GLineLayout.h
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/6.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GLineLayout : NSObject

@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) id  line;
@property (nonatomic, assign) CGFloat  linespace;
@property (nonatomic, assign) CGFloat  linePonintY;
+ (instancetype)line:(id)line Layout:(CGRect)rect;

@end
