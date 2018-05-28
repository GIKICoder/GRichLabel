//
//  GMenuController.m
//  GMenuController
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GMenuController.h"
#import "GMenuEffectsWindow.h"
#import "GMenuViewContainer.h"
NSNotificationName  const GMenuControllerWillShowMenuNotification = @"GMenuControllerWillShowMenuNotification_private";
NSNotificationName  const GMenuControllerDidShowMenuNotification= @"GMenuControllerDidShowMenuNotification_private";
NSNotificationName  const GMenuControllerWillHideMenuNotification= @"GMenuControllerWillHideMenuNotification_private";
NSNotificationName  const GMenuControllerDidHideMenuNotification= @"GMenuControllerDidHideMenuNotification_private";
NSNotificationName  const GMenuControllerMenuFrameDidChangeNotification= @"GMenuControllerMenuFrameDidChangeNotification_private";

@interface GMenuController()
{
    BOOL _showMenu;
}
@property (nonatomic, strong,readwrite) GMenuViewContainer * menuViewContainer;
@property (nonatomic, weak) UIView * targetView;
@end

@implementation GMenuController

#pragma mark - init

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

#pragma mark - public Method

+ (GMenuController *)sharedMenuController
{
    static GMenuController *inst = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [GMenuController new];
    });
    return inst;
}

- (BOOL)isMenuVisible
{
    return _showMenu;
}

- (void)setMenuVisible:(BOOL)menuVisible
{
    [self setMenuVisible:menuVisible animated:YES];
}

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated
{
    _showMenu = menuVisible;
    if (menuVisible) {
        [[NSNotificationCenter defaultCenter] postNotificationName:GMenuControllerWillShowMenuNotification object:nil];
        [self showMenuWithAnimated:animated];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:GMenuControllerWillHideMenuNotification object:nil];
        [[GMenuEffectsWindow sharedWindow] hideMenu:self.menuViewContainer];
    }
}

- (void)showMenuWithAnimated:(BOOL)animated
{
   [[GMenuEffectsWindow sharedWindow] showMenu:self.menuViewContainer animation:YES];
}

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView
{
    if (!self.menuViewContainer) return;
    self.targetView = targetView;
    [self.menuViewContainer setTargetRect:targetRect inView:targetView];
}

- (void)setMenuItems:(NSArray<GMenuItem *> *)menuItems
{
    _menuItems = menuItems;
    self.menuViewContainer.menuItems = menuItems;
}

- (void)update
{
    [self.menuViewContainer processMenuFrame];
}

- (void)reset
{
    [self.menuViewContainer initConfigs];
}

- (CGRect)menuFrame
{
    return self.menuViewContainer ? self.menuViewContainer.frame :CGRectZero;
}

- (void)setArrowDirection:(GMenuControllerArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    self.menuViewContainer.arrowDirection = arrowDirection;
}

- (GMenuViewContainer *)menuViewContainer
{
    if (!_menuViewContainer) {
        _menuViewContainer = [GMenuViewContainer new];
    }
    return _menuViewContainer;
}
@end

@implementation GMenuItem

- (instancetype)initWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        self.title = title;
        self.target = target;
        self.action = action;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage*)image target:(id)target action:(SEL)action
{
    self = [super init];
    if (self) {
        self.title = title;
        self.target = target;
        self.action = action;
        self.image = image;
    }
    return self;
}

@end
