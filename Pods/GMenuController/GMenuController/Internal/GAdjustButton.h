//
//  GAdjustButton.h
//  GMenuController
//
//  Created by GIKI on 2017/10/19.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GAdjustButtonIMGPosition) {
    GAdjustButtonIMGPositionLeft = 0, //Default
    GAdjustButtonIMGPositionRight,
    GAdjustButtonIMGPositionTop,
    GAdjustButtonIMGPositionBottom,
};

@interface GAdjustButton : UIButton

@property (nonatomic, assign) GAdjustButtonIMGPosition  imagePosition;

@end
