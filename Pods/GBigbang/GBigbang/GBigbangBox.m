//
//  GBigbangBox.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/19.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GBigbangBox.h"

@implementation GBigbangBox

+(NSArray *)bigBang:(NSString *)string
{
    __block NSMutableArray * array = [NSMutableArray array];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByWords usingBlock:^(NSString *subString, NSRange subStringRange, NSRange enclosingRange, BOOL *stop){
        
        if (subStringRange.location > enclosingRange.location) {
            NSRange preRange =  NSMakeRange(enclosingRange.location, subStringRange.location);
            NSString * preString = [string substringWithRange:preRange];
            [preString enumerateSubstringsInRange:NSMakeRange(0, preString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring1, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                [array addObject:[GBigbangItem bigbangText:substring1 isSymbol:YES]];
            }];
        }
        
        if (![GBigbangBox isEmptAllSapce:subString]) {
            [array addObject:[GBigbangItem bigbangText:subString isSymbol:NO]];
        }
 
        if (subStringRange.location > enclosingRange.location && (subStringRange.location + subStringRange.length) < (enclosingRange.location +enclosingRange.length)) {
            
            NSRange nextRange =  NSMakeRange(subStringRange.location + subStringRange.length, (enclosingRange.location +enclosingRange.length)-(subStringRange.location + subStringRange.length));
            NSString * nextString = [string substringWithRange:nextRange];
            [nextString enumerateSubstringsInRange:NSMakeRange(0, nextString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring2, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                [array addObject:[GBigbangItem bigbangText:substring2 isSymbol:YES]];
            }];
        }
        
        if (subStringRange.length<enclosingRange.length && subStringRange.location == enclosingRange.location) {
            NSRange subRan = NSMakeRange(subStringRange.location+subStringRange.length, enclosingRange.length-subStringRange.length);
            NSString *subStr = [string substringWithRange:subRan];
            if (subStr.length > 0) {
                [subStr enumerateSubstringsInRange:NSMakeRange(0, subStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring3, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    [array addObject:[GBigbangItem bigbangText:substring3 isSymbol:YES]];
                }];
            }
        }
    }];
    return array.copy;
}


/**
 是否为nil 或者全部为空格
 
 @return <#return value description#>
 */
+ (BOOL)isEmptAllSapce:(NSString*)string
{
    
    if (!string) {
        return YES;
    } else {
        if (![string isKindOfClass:[NSString class]]) {
            return NO;
        }
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}

@end

@interface GBigbangItem()
@property (nonatomic, copy,readwrite) NSString * text;
@property (nonatomic, assign,readwrite) BOOL isSymbolOrEmoji;
@end


@implementation GBigbangItem

+(instancetype)bigbangText:(NSString*)text isSymbol:(BOOL)isSymbol
{
    GBigbangItem *item = [GBigbangItem new];
    item.text = text;
    item.isSymbolOrEmoji = isSymbol;
    return item;
}
@end
