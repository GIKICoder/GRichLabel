//
//  GEmojiConfigManager.h
//  GRichLabel
//
//  Created by GIKI on 2017/9/6.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GEmojiConfigManager : NSObject

+ (GEmojiConfigManager *)sharedInstance;

- (void)setEmojiConfigs:(NSDictionary*)configs;

- (NSDictionary*)getEmojiConfigs;

- (NSString*)getEmojiImageName:(NSString*)emojiCode;

@end
