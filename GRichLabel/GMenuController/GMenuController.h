//
//  GMenuController.h
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GMenuControllerArrowDirection) {
    GMenuControllerArrowDefault, // up or down based on screen location
    GMenuControllerArrowUp ,       // Forced upward. If the screen is not displayed,  Will do anchor displacement
    GMenuControllerArrowDown ,     // Forced down
};

@class GMenuItem;

@interface GMenuController : NSObject

+ (GMenuController *)sharedMenuController;

@property(nonatomic,getter=isMenuVisible) BOOL menuVisible;        // default is NO

@property(nonatomic) GMenuControllerArrowDirection arrowDirection ; // default is GMenuControllerArrowDefault

@property(nullable, nonatomic,copy) NSArray<GMenuItem *> *menuItems; // default is nil. these are in addition to the standard items

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated;

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView;

- (void)update;

@property(nonatomic,readonly) CGRect menuFrame;

@end

UIKIT_EXTERN NSNotificationName const GMenuControllerWillShowMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerDidShowMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerWillHideMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerDidHideMenuNotification;
UIKIT_EXTERN NSNotificationName const GMenuControllerMenuFrameDidChangeNotification;

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface GMenuItem : NSObject
- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@property(nonatomic,copy) NSString *title;
@property (nonatomic, strong) id target;
@property(nonatomic)      SEL       action;
@end
NS_ASSUME_NONNULL_END
