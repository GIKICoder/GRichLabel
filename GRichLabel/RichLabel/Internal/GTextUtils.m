//
//  GTextUtils.m
//  GRichLabel
//
//  Created by GIKI on 2017/9/2.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTextUtils.h"
#import "UIView+GText.h"
#import <Accelerate/Accelerate.h>

CGSize GTextScreenSize() {
    static CGSize size;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size = [UIScreen mainScreen].bounds.size;
        if (size.height < size.width) {
            CGFloat tmp = size.height;
            size.height = size.width;
            size.width = tmp;
        }
    });
    return size;
}

CGFloat GTextScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}


BOOL GTextIsAppExtension() {
    static BOOL isAppExtension = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIApplication");
        if(!cls || ![cls respondsToSelector:@selector(sharedApplication)]) isAppExtension = YES;
        if ([[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]) isAppExtension = YES;
    });
    return isAppExtension;
}

UIApplication *GTextSharedApplication() {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    return GTextIsAppExtension() ? nil : [UIApplication performSelector:@selector(sharedApplication)];
#pragma clang diagnostic pop
}


// return 0 when succeed
static int matrix_invert(__CLPK_integer N, double *matrix) {
    __CLPK_integer error = 0;
    __CLPK_integer pivot_tmp[6 * 6];
    __CLPK_integer *pivot = pivot_tmp;
    double workspace_tmp[6 * 6];
    double *workspace = workspace_tmp;
    bool need_free = false;
    
    if (N > 6) {
        need_free = true;
        pivot = malloc(N * N * sizeof(__CLPK_integer));
        if (!pivot) return -1;
        workspace = malloc(N * sizeof(double));
        if (!workspace) {
            free(pivot);
            return -1;
        }
    }
    
    dgetrf_(&N, &N, matrix, &N, pivot, &error);
    
    if (error == 0) {
        dgetri_(&N, matrix, &N, pivot, workspace, &N, &error);
    }
    
    if (need_free) {
        free(pivot);
        free(workspace);
    }
    return error;
}

CGAffineTransform GTextCGAffineTransformGetFromPoints(CGPoint before[3], CGPoint after[3]) {
    if (before == NULL || after == NULL) return CGAffineTransformIdentity;
    
    CGPoint p1, p2, p3, q1, q2, q3;
    p1 = before[0]; p2 = before[1]; p3 = before[2];
    q1 =  after[0]; q2 =  after[1]; q3 =  after[2];
    
    double A[36];
    A[ 0] = p1.x; A[ 1] = p1.y; A[ 2] = 0; A[ 3] = 0; A[ 4] = 1; A[ 5] = 0;
    A[ 6] = 0; A[ 7] = 0; A[ 8] = p1.x; A[ 9] = p1.y; A[10] = 0; A[11] = 1;
    A[12] = p2.x; A[13] = p2.y; A[14] = 0; A[15] = 0; A[16] = 1; A[17] = 0;
    A[18] = 0; A[19] = 0; A[20] = p2.x; A[21] = p2.y; A[22] = 0; A[23] = 1;
    A[24] = p3.x; A[25] = p3.y; A[26] = 0; A[27] = 0; A[28] = 1; A[29] = 0;
    A[30] = 0; A[31] = 0; A[32] = p3.x; A[33] = p3.y; A[34] = 0; A[35] = 1;
    
    int error = matrix_invert(6, A);
    if (error) return CGAffineTransformIdentity;
    
    double B[6];
    B[0] = q1.x; B[1] = q1.y; B[2] = q2.x; B[3] = q2.y; B[4] = q3.x; B[5] = q3.y;
    
    double M[6];
    M[0] = A[ 0] * B[0] + A[ 1] * B[1] + A[ 2] * B[2] + A[ 3] * B[3] + A[ 4] * B[4] + A[ 5] * B[5];
    M[1] = A[ 6] * B[0] + A[ 7] * B[1] + A[ 8] * B[2] + A[ 9] * B[3] + A[10] * B[4] + A[11] * B[5];
    M[2] = A[12] * B[0] + A[13] * B[1] + A[14] * B[2] + A[15] * B[3] + A[16] * B[4] + A[17] * B[5];
    M[3] = A[18] * B[0] + A[19] * B[1] + A[20] * B[2] + A[21] * B[3] + A[22] * B[4] + A[23] * B[5];
    M[4] = A[24] * B[0] + A[25] * B[1] + A[26] * B[2] + A[27] * B[3] + A[28] * B[4] + A[29] * B[5];
    M[5] = A[30] * B[0] + A[31] * B[1] + A[32] * B[2] + A[33] * B[3] + A[34] * B[4] + A[35] * B[5];
    
    CGAffineTransform transform = CGAffineTransformMake(M[0], M[2], M[1], M[3], M[4], M[5]);
    return transform;
}

CGAffineTransform GTextCGAffineTransformGetFromViews(UIView *from, UIView *to) {
    if (!from || !to) return CGAffineTransformIdentity;
    
    CGPoint before[3], after[3];
    before[0] = CGPointMake(0, 0);
    before[1] = CGPointMake(0, 1);
    before[2] = CGPointMake(1, 0);
    after[0] = [from convertPoint:before[0] toViewOrWindow:to];
    after[1] = [from convertPoint:before[1] toViewOrWindow:to];
    after[2] = [from convertPoint:before[2] toViewOrWindow:to];
    
    return GTextCGAffineTransformGetFromPoints(before, after);
}


@implementation GTextUtils

+ (void)enumerateSubstringsInRange:(NSRange)range string:(NSString *)string usingBlock:(void (^)(NSString * substring, NSRange substringRange, BOOL *stop))block
{
    @try {
        if (range.length == 0 || range.location > string.length || range.location+range.length > string.length) {
            range = NSMakeRange(0, string.length);
        }
        
        __block BOOL hasStop = NO;
        [string enumerateSubstringsInRange:range options:NSStringEnumerationByWords usingBlock:^(NSString *subString, NSRange subStringRange, NSRange enclosingRange, BOOL *stop){
            
            if (subStringRange.location > enclosingRange.location) {
                NSRange preRange =  NSMakeRange(enclosingRange.location, subStringRange.location);
                NSString * preString = [string substringWithRange:preRange];
                [preString enumerateSubstringsInRange:NSMakeRange(0, preString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring1, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    
                    BOOL tempStop = NO;
                    if (block) {
                        block(substring1,subStringRange,&tempStop);
                    }
                    if (tempStop) {
                        hasStop = YES;
                        *stop = YES;
                    }
                }];
            }
            if (hasStop) {
                *stop = YES;
            }
            if (subString) {
                BOOL tempStop = NO;
                if (block) {
                    block(subString,subStringRange,&tempStop);
                }
                if (tempStop) {
                    *stop = YES;
                }
            }
            if (subStringRange.location > enclosingRange.location && (subStringRange.location + subStringRange.length) < (enclosingRange.location +enclosingRange.length)) {
                
                NSRange nextRange =  NSMakeRange(subStringRange.location + subStringRange.length, (enclosingRange.location +enclosingRange.length)-(subStringRange.location + subStringRange.length));
                NSString * nextString = [string substringWithRange:nextRange];
                [nextString enumerateSubstringsInRange:NSMakeRange(0, nextString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring2, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    BOOL tempStop = NO;
                    if (block) {
                        block(substring2,subStringRange,&tempStop);
                    }
                    if (tempStop) {
                        hasStop = YES;
                        *stop = YES;
                    }
                }];
            }
            if (hasStop) {
                *stop = YES;
            }
            if (subStringRange.length<enclosingRange.length && subStringRange.location == enclosingRange.location) {
                NSRange subRan = NSMakeRange(subStringRange.location+subStringRange.length, enclosingRange.length-subStringRange.length);
                if (string.length > subRan.location+subRan.length) {
                    NSString *subStr = [string substringWithRange:subRan];
                    if (subStr.length > 0) {
                        [subStr enumerateSubstringsInRange:NSMakeRange(0, subStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring3, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                            BOOL tempStop = NO;
                            if (block) {
                                block(substring3,subStringRange,&tempStop);
                            }
                            if (tempStop) {
                                hasStop = YES;
                                *stop = YES;
                            }
                        }];
                    }
                }
            }
            if (hasStop) {
                *stop = YES;
            }
        }];
    
    } @catch(NSException *exception)  {

    }
}

+(NSArray *)splitByWords:(NSString *)string range:(NSRange)range
{
    @try {
        __block NSMutableArray * array = [NSMutableArray array];
        if (range.length == 0 || range.location > string.length || range.location+range.length > string.length) {
            range = NSMakeRange(0, string.length);
        }
        [string enumerateSubstringsInRange:range options:NSStringEnumerationByWords usingBlock:^(NSString *subString, NSRange subStringRange, NSRange enclosingRange, BOOL *stop){
            
            if (subStringRange.location > enclosingRange.location) {
                NSRange preRange =  NSMakeRange(enclosingRange.location, subStringRange.location);
                NSString * preString = [string substringWithRange:preRange];
                [preString enumerateSubstringsInRange:NSMakeRange(0, preString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring1, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    [array addObject:substring1];
                }];
            }
            
            if (subString) {
                [array addObject:subString];
            }
            
            if (subStringRange.location > enclosingRange.location && (subStringRange.location + subStringRange.length) < (enclosingRange.location +enclosingRange.length)) {
                
                NSRange nextRange =  NSMakeRange(subStringRange.location + subStringRange.length, (enclosingRange.location +enclosingRange.length)-(subStringRange.location + subStringRange.length));
                NSString * nextString = [string substringWithRange:nextRange];
                [nextString enumerateSubstringsInRange:NSMakeRange(0, nextString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring2, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                    [array addObject:substring2];
                }];
            }
            
            if (subStringRange.length<enclosingRange.length && subStringRange.location == enclosingRange.location) {
                NSRange subRan = NSMakeRange(subStringRange.location+subStringRange.length, enclosingRange.length-subStringRange.length);
                if (string.length > subRan.location+subRan.length) {
                    NSString *subStr = [string substringWithRange:subRan];
                    if (subStr.length > 0) {
                        [subStr enumerateSubstringsInRange:NSMakeRange(0, subStr.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring3, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                            [array addObject:substring3];
                        }];
                    }
                }
            }
        }];
        return array.copy;
    } @catch(NSException *exception)  {
        return [NSArray array];
    }
}

@end
