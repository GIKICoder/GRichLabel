//
//  GMagnifiterWindow.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/2.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GMagnifiterINST [GMagnifiterWindow sharedWindow]

@class GMagnifiter;
@interface GMagnifiterWindow : UIWindow

+ (instancetype)sharedWindow;

- (void)showMagnifier:(GMagnifiter *)magnifiter;

- (void)moveMagnifier:(GMagnifiter *)magnifiter;

- (void)hideMagnifier:(GMagnifiter *)magnifiter;

@end
