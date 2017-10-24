//
//  GMenuEffectsWindow.h
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMenuViewContainer;
@interface GMenuEffectsWindow : UIWindow

+ (instancetype)sharedWindow;

- (void)showMenu:(GMenuViewContainer *)menu animation:(BOOL)animation;

- (void)hideMenu:(GMenuViewContainer *)menu;

@end
    
