//
//  GEmojiConfigManager.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/6.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GEmojiConfigManager.h"

@interface GEmojiConfigManager ()
@property (nonatomic, strong) NSDictionary * emojiDict;
@end

@implementation GEmojiConfigManager

+ (GEmojiConfigManager *)sharedInstance
{
    static GEmojiConfigManager *INST = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INST = [[GEmojiConfigManager alloc] init];
    });
    return INST;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
       _emojiDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"expression" ofType:@"plist"]];
    }
    return self;
}

- (void)setEmojiConfigs:(NSDictionary*)configs
{
    if (!configs) return;
    _emojiDict = configs;
}

- (NSDictionary*)getEmojiConfigs
{
    return _emojiDict;
}

- (NSString*)getEmojiImageName:(NSString*)emojiCode
{
    return [_emojiDict objectForKey:emojiCode];
}

@end
