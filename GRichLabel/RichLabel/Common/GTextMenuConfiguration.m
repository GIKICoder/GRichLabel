//
//  GTextMenuConfiguration.m
//  GRichLabel
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTextMenuConfiguration.h"
#import "GRichLabel.h"
#import "GMenuController.h"
#import "NSMutableAttributedString+GRichLabel.h"
#import "NSAttributedString+GRichLabel.h"
#import "UIView+GText.h"

@interface GTextMenuConfiguration ()
@property (nonatomic, weak) GRichLabel * richLabel;
@property (nonatomic, strong) NSString * selectText;
@property (nonatomic, strong) NSArray * innerItems;
@end

@implementation GTextMenuConfiguration

- (instancetype)init
{
    self = [super init];
    if (self) {
            GMenuItem *copyItem = [[GMenuItem alloc] initWithTitle:@"拷贝" target:self action:@selector(copyItem:)];
            GMenuItem *selectAllItem = [[GMenuItem alloc] initWithTitle:@"全选" target:self action:@selector(selectAllItem:)];
            GMenuItem *shareItem = [[GMenuItem alloc] initWithTitle:@"共享" target:self action:@selector(shareItem:)];
        
            NSArray *items = [NSArray arrayWithObjects:copyItem,selectAllItem,shareItem,nil];
            self.menuItems = items;
            self.innerItems = items;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSelection) name:GMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}

- (void)ConfigMenuWithRichLabel:(GRichLabel*)richLabel
{
    self.richLabel = richLabel;
}

- (void)ShowRichLabelTextMenuWithTargetRect:(CGRect)targetRect
{
    if (self.menuItems.count == 0) return;
        
        GMenuController *menuController = [GMenuController sharedMenuController];
        menuController.menuViewContainer.hasAutoHide = NO;
        NSArray *items = self.menuItems;
        [menuController setMenuItems:items];

        [menuController setTargetRect:targetRect inView:self.richLabel];
        [menuController setMenuVisible:YES animated:YES];
    
}

- (void)resetSelection
{
    if ([self.richLabel getSelectRange].length > 0) {
        [self.richLabel resetSelection];
    }
}

- (void)HideRichLabelTextMenu
{

    GMenuController *menu = [GMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}

/**
 copy Method
 
 @param sender sender
 */
- (void)copyItem:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",[self.richLabel getSelectText]]];
    
    [self.richLabel resetSelection];
}

/**
 select All Method
 
 @param sender sender
 */
- (void)selectAllItem:(id)sender
{
    [self.richLabel setSelectAllRange];
    [self.richLabel showSelectionView];
    [self showAfterSelectAllMenu];
}

/**
 share Method
 
 @param sender sender
 */
- (void)shareItem:(id)sender
{
    NSString *textToShare = [NSString stringWithFormat:@"%@",[self.richLabel getSelectText]];
    
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    __weak typeof(self) weakSelf = self;
    
    [[self.richLabel getCurrentViewController] presentViewController:activityVC animated:YES completion:^{
        [weakSelf.richLabel resetSelection];
    }];
    
}

/**
 显示全部选择后的menu
 */
- (void)showAfterSelectAllMenu
{
    GMenuItem *copyItem = [[GMenuItem alloc] initWithTitle:@"拷贝" target:self action:@selector(copyItem:)];
    GMenuItem *shareItem = [[GMenuItem alloc] initWithTitle:@"共享" target:self action:@selector(shareItem:)];
    NSArray *items = [NSArray arrayWithObjects:copyItem,shareItem,nil];
    self.menuItems = items;
    [self.richLabel showTextMenu];
    self.menuItems = self.innerItems;
}


@end


