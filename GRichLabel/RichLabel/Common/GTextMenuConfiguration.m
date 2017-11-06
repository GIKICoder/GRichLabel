//
//  GTextMenuConfiguration.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTextMenuConfiguration.h"
#import "GRichLabel.h"
#import "GMenuController.h"
#import "GBigbang.h"
#import "NSMutableAttributedString+GRichLabel.h"
#import "NSAttributedString+GRichLabel.h"
@interface GRichLabel(TextMenuDefault)

@end

@implementation GRichLabel(TextMenuDefault)
/**
 copy Method
 
 @param sender sender
 */
- (void)copyItem:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",[self getSelectText]]];
    
    [self resetSelection];
}
/**
 select All Method
 
 @param sender sender
 */
- (void)selectAllItem:(id)sender
{
    [self setSelectAllRange];
    [self showSelectionView];
    [self showAfterSelectAllMenu];
}

/**
 share Method
 
 @param sender sender
 */
- (void)shareItem:(id)sender
{
    NSString *textToShare = [NSString stringWithFormat:@"%@",[self getSelectText]];
    
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    __weak typeof(self) weakSelf = self;
    
    [[self getCurrentViewController] presentViewController:activityVC animated:YES completion:^{
        [weakSelf resetSelection];
    }];
    
}

/**
 显示全部选择后的menu
 */
- (void)showAfterSelectAllMenu
{
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
    UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
    self.menuConfiguration.menuItems = @[copyItem,shareItem];
    [self showTextMenu];
}
@end

@interface GTextMenuConfiguration ()
@property (nonatomic, weak) GRichLabel * richLabel;
@property (nonatomic, strong) NSString * selectText;
@property (nonatomic, strong) GTagFlowContainer *container;
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
        
        self.useGMenuController = YES;
        if (self.useGMenuController) {
            GMenuItem *copyItem = [[GMenuItem alloc] initWithTitle:@"拷贝" target:self action:@selector(copyItem:)];
            GMenuItem *selectAllItem = [[GMenuItem alloc] initWithTitle:@"全选" target:self action:@selector(selectAllItem:)];
            GMenuItem *shareItem = [[GMenuItem alloc] initWithTitle:@"共享" target:self action:@selector(shareItem:)];
            GMenuItem *bigbangItem = [[GMenuItem alloc] initWithTitle:@"bigbang" target:self action:@selector(bigbang:)];
            GMenuItem *underlineItem = [[GMenuItem alloc] initWithTitle:@"划线" target:self action:@selector(underline:)];
//            ,bigbangItem,underlineItem,
            NSArray *items = [NSArray arrayWithObjects:copyItem,selectAllItem,shareItem,nil];
            self.menuItems = items;
            
            GTagFlowContainer *container = [GTagFlowContainer new];
            self.container = container;
            
            self.container.actionBlock = ^(NSString *actionTitle, NSString *newText) {
                
            };
            
        } else {
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
            UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(selectAllItem:)];
            UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
            NSArray *items = [NSArray arrayWithObjects:copyItem,selectAllItem,shareItem,nil];
            self.menuItems = items;
        }
    }
    return self;
}

- (void)showMenuWithTargetRect:(CGRect)targetRect selectRange:(NSRange)selectRange
{
    if (self.menuItems.count == 0) return;
    if (self.useGMenuController) {
        
        GMenuController *menuController = [GMenuController sharedMenuController];
        
        NSArray *items = self.menuItems;
        [menuController setMenuItems:items];
        
        [menuController setTargetRect:targetRect inView:self.richLabel];
        [menuController setMenuVisible:YES animated:YES];
    } else {
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        NSArray *items = self.menuItems;
        [menuController setMenuItems:items];
        
        [menuController setTargetRect:targetRect inView:self.richLabel];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (void)hideTextMenu
{
    if (self.useGMenuController) {
        GMenuController *menu = [GMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
    } else {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
    }
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

- (void)underline:(id)sender
{
    NSRange selectRange = [self.richLabel getSelectRange];
    [self.richLabel resetSelection];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.richLabel.attributedString];
    [string g_setUnderlineStyle:NSUnderlineStyleSingle range:selectRange];
    [string g_setUnderlineColor:[UIColor redColor] range:selectRange];
    GDrawTextBuilder *buider = [GDrawTextBuilder buildDrawTextSize:self.richLabel.frame.size attributedString:string.copy];
    self.richLabel.textBuilder = buider;
    
}

- (void)bigbang:(id)sender
{
    NSArray * array = [GBigbangBox bigBang:[self.richLabel getSelectText]];
    __block NSMutableArray *flows = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(GBigbangItem  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTagFlowLayout *layout = [GTagFlowLayout tagFlowLayoutWithText:obj.text];
        [flows addObject:layout];
        if (obj.isSymbolOrEmoji) {
            layout.appearance.backgroundColor = [UIColor grayColor];
            layout.appearance.textColor = [UIColor blackColor];
        }
    }];
    [self.container configDatas:flows.copy];
    [self.container show];
    [self.richLabel resetSelection];
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
}


@end


