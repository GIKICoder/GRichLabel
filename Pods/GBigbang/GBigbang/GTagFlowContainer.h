//
//  GTagFlowContainer.h
//  GBigbangExample
//
//  Created by GIKI on 2017/10/20.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTagFlowView.h"

#define kGPopContainerHiddenKey @"kGPopContainerHiddenKey"

typedef void(^GTagFlowActionBlock) (NSString *actionTitle,NSString*newText);

@interface GTagFlowContainer : UIView

/// actionBtn 点击block
@property (nonatomic, copy) GTagFlowActionBlock  actionBlock;
@property (nonatomic, strong) NSArray<NSString*> * actionBtnItems;

@property (nonatomic, strong,readonly) GTagFlowView * flowView;


- (void)configDatas:(NSArray<GTagFlowLayout*>*)flowDatas;
- (void)show;
- (void)hide;
@end
