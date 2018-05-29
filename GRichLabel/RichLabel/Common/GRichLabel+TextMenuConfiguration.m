//
//  GRichLabel+TextMenuConfiguration.m
//  GRichLabelExample
//
//  Created by GIKI on 2018/5/29.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GRichLabel+TextMenuConfiguration.h"

@implementation GRichLabelWeakReference
+ (instancetype)weakReference:(id)weakObj
{
    GRichLabelWeakReference * weak = [GRichLabelWeakReference new];
    weak.weakObj = weakObj;
    return weak;
}
@end

@implementation GRichLabel (TextMenuConfiguration)

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    /*
     ------------------------------------------------------
     Default menu actions list:
     cut:                                   Cut
     copy:                                  Copy
     select:                                Select
     selectAll:                             Select All
     paste:                                 Paste
     delete:                                Delete
     _promptForReplace:                     Replace...
     _transliterateChinese:                 简⇄繁
     _showTextStyleOptions:                 𝐁𝐼𝐔
     _define:                               Define
     _addShortcut:                          Add...
     _accessibilitySpeak:                   Speak
     _accessibilitySpeakLanguageSelection:  Speak...
     _accessibilityPauseSpeaking:           Pause Speak
     makeTextWritingDirectionRightToLeft:   ⇋
     makeTextWritingDirectionLeftToRight:   ⇌
     
     ------------------------------------------------------
     Default attribute modifier list:
     toggleBoldface:
     toggleItalics:
     toggleUnderline:
     increaseSize:
     decreaseSize:
     */
    
    if (self.getSelectRange.length > 0) {

        if (action == @selector(copy:)) {
            return YES;
        }
        if (action == @selector(selectAll:)) {
            
            return self.getSelectRange.length < self.textBuilder.attributedString.string.length;
        }

        NSString *selString = NSStringFromSelector(action);
        if ([selString hasSuffix:@"define:"] && [selString hasPrefix:@"_"]) {
            return [self getCurrentViewController] != nil;
        }
    }
    return NO;
}

- (void)ShowRichLabelTextMenuWithTargetRect:(CGRect)targetRect
{
    if (!self.isFirstResponder) {
        [self becomeFirstResponder];
    }
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect:targetRect inView:self];
    [menuController update];
    [menuController setMenuVisible:YES animated:YES];
}

- (void)HideRichLabelTextMenu
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}

/**
 copy Method
 
 @param sender sender
 */
- (void)copy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",[self getSelectText]]];
    [self resetSelection];
}

/**
 select All Method
 
 @param sender sender
 */
- (void)selectAll:(id)sender
{
    [self setSelectAllRange];
    [self showSelectionView];
    [self showTextMenu];
}

- (void)_define:(id)sender
{
    NSString *string = [self getSelectText];
    if (string.length == 0) return;
    BOOL resign = [self resignFirstResponder];
    if (!resign) return;
    [self resetSelection];
    
    UIReferenceLibraryViewController* vc = [[UIReferenceLibraryViewController alloc] initWithTerm:string];
    vc.view.backgroundColor = [UIColor whiteColor];
    [[self getCurrentViewController] presentViewController:vc animated:YES completion:^{}];
}

@end
