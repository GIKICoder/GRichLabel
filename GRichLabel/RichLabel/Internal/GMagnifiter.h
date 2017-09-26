//
//  GMagnifiter.h
//  GRichLabel
//
//  Created by GIKI on 2017/8/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

/**
 most of the code reference from YYText! Thanks!
 gitHup:https://github.com/ibireme/YYText/blob/master/YYText/Component/YYTextMagnifier.h
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GTextMagnifierType) {
    GTextMagnifierTypeCaret,
    GTextMagnifierTypeRanged,
};

@interface GMagnifiter : UIView

+ (id)magnifierWithType:(GTextMagnifierType)type;

@property (nonatomic, weak) UIView *hostView;
@property (nonatomic, readonly) GTextMagnifierType type;
@property (nonatomic, readonly) CGSize fitSize;
@property (nonatomic, readonly) CGSize snapshotSize;
@property (nonatomic, strong) UIImage *snapshot;
@property (nonatomic, assign) CGPoint hostCaptureCenter;
@property (nonatomic, assign) CGPoint hostPopoverCenter;

@property (nonatomic) BOOL captureDisabled;
@property (nonatomic) BOOL captureFadeAnimation;

@end
