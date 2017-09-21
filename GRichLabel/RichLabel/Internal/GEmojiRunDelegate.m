//
//  GEmojiRunDelegate.m
//  GRichTextExample
//
//  Created by GIKI on 2017/9/6.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GEmojiRunDelegate.h"
#import <CoreText/CoreText.h>
#import "GTextUtils.h"
static void DeallocCallback(void *ref) {
    GEmojiRunDelegate *delegate = (__bridge_transfer GEmojiRunDelegate *)(ref);
    delegate = nil;
}

static CGFloat AscentCallback(void *ref) {
    GEmojiRunDelegate *delegate = (__bridge GEmojiRunDelegate *)(ref);
    return  GTextEmojiGetAscentWithFontSize(delegate.textFont.pointSize);;
}

static CGFloat DecentCallback(void *ref) {
    GEmojiRunDelegate *delegate = (__bridge GEmojiRunDelegate *)(ref);
    return GTextEmojiGetDescentWithFontSize(delegate.textFont.pointSize);
}

static CGFloat WidthCallback(void *ref) {
    GEmojiRunDelegate *delegate = (__bridge GEmojiRunDelegate *)(ref);
    CGRect bound = delegate.bounds;
    return  bound.size.width + 2 * bound.origin.x;
}

@interface GEmojiRunDelegate()
@property (nonatomic, assign,readwrite) CGRect bounds;
@end

@implementation GEmojiRunDelegate

- (CTRunDelegateRef)GetCTRunDelegate CF_RETURNS_RETAINED {
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = DeallocCallback;
    callbacks.getAscent = AscentCallback;
    callbacks.getDescent = DecentCallback;
    callbacks.getWidth = WidthCallback;
    return CTRunDelegateCreate(&callbacks, (__bridge_retained void *)(self.copy));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
     self.bounds = GTextEmojiGetGlyphBoundingRectWithFontSize(textFont.pointSize);
}

- (id)copyWithZone:(NSZone *)zone {
    
    typeof(self) one = [self.class new];
    one.userInfo = self.userInfo;
    one.emojiImageName = self.emojiImageName;
    one.textFont = self.textFont;
    return one;
}
@end


