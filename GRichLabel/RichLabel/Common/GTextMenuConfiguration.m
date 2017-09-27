//
//  GTextMenuConfiguration.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTextMenuConfiguration.h"
#import "GRichLabel.h"

@interface GTextMenuConfiguration ()
@property (nonatomic, weak) GRichLabel * richLabel;
@property (nonatomic, strong) NSString * selectText;
@property (nonatomic, strong) NSArray * menuItems;
@end

@implementation GTextMenuConfiguration

+ (instancetype)textMenuConfig:(GRichLabel*)richLabel
{
    GTextMenuConfiguration * config = [GTextMenuConfiguration new];
    config.richLabel = richLabel;
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
        UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(selectAllItem:)];
        UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
        NSArray *items = [NSArray arrayWithObjects:copyItem,selectAllItem,shareItem,nil];
        self.menuItems = items;
    }
    return self;
}

- (void)showMenuWithTargetRect:(CGRect)targetRect selectRange:(NSRange)selectRange
{
     [self.richLabel becomeFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
    UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(selectAllItem:)];
    UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
    NSArray *items = [NSArray arrayWithObjects:copyItem,selectAllItem,shareItem,nil];
    [menuController setMenuItems:items];

    [menuController setTargetRect:targetRect inView:self.richLabel];
    [menuController setMenuVisible:YES animated:YES];
    
}

- (void)hideTextMenu
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
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
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
    UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
    NSArray *items = [NSArray arrayWithObjects:copyItem,shareItem,nil];
    self.menuItems = items;
    [self.richLabel showTextMenu];
}
@end
