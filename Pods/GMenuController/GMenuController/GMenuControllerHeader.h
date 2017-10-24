//
//  GMenuControllerHeader.h
//  GMenuController
//
//  Created by GIKI on 2017/10/19.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#ifndef GMenuControllerHeader_h
#define GMenuControllerHeader_h

typedef NS_ENUM(NSUInteger, GMenuControllerArrowDirection) {
    GMenuControllerArrowDefault, // up or down based on screen location
    GMenuControllerArrowUp ,       // Forced upward. If the screen is not displayed,  Will do anchor displacement
    GMenuControllerArrowDown ,     // Forced down
};

UIKIT_EXTERN NSNotificationName const GMenuControllerWillShowMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerDidShowMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerWillHideMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerDidHideMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerMenuFrameDidChangeNotification;

#endif /* GMenuControllerHeader_h */
