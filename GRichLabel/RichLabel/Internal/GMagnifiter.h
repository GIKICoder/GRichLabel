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
    GTextMagnifierTypeCaret,  ///< Circular magnifier
    GTextMagnifierTypeRanged, ///< Round rectangle magnifier
};

@interface GMagnifiter : UIView

///
+ (id)magnifierWithType:(GTextMagnifierType)type;

@property (nonatomic, weak) UIView *hostView;             ///< The coordinate based view.
@property (nonatomic, readonly) GTextMagnifierType type;  ///< Type of magnifier
@property (nonatomic, readonly) CGSize fitSize;            ///< The 'best' size for magnifier view.
@property (nonatomic, readonly) CGSize snapshotSize;       ///< The 'best' snapshot image size for magnifier.
@property (nonatomic, strong) UIImage *snapshot; ///< The image in magnifier (readwrite).
@property (nonatomic, assign) CGPoint hostCaptureCenter;  ///< The snapshot capture center in `hostView`.
@property (nonatomic, assign) CGPoint hostPopoverCenter;  ///< The popover center in `hostView`.

@property (nonatomic) BOOL captureDisabled;               ///< A hint for `YYTextEffectWindow` to disable capture.
@property (nonatomic) BOOL captureFadeAnimation;

@end
