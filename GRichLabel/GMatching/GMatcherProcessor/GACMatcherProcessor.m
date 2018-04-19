//
//  GACMatcherProcessor.m
//  GMatchingKit
//
//  Created by GIKI on 2018/4/18.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GACMatcherProcessor.h"
@interface GACNode : NSObject
@property(nonatomic, strong) NSMutableDictionary<NSString*, GACNode*>*   next;
@property(nonatomic, strong) GACNode*                                    failed;
@property(nonatomic, copy) NSString*                                    storeString;
@property (nonatomic, strong) id                                        userInfo;
@end
@implementation GACNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        _next = [[NSMutableDictionary alloc] init];
        _failed = nil;
        _storeString = nil;
    }
    return self;
}
@end
@interface GACQueue : NSObject
- (void)addQueue:(id)object;
- (id)getQueue;
- (BOOL)isEmpty;
- (void)clean;
@end
@implementation GACQueue
{
    NSMutableArray * _queue;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _queue = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)addQueue:(id)object
{
    [_queue addObject:object];
}
- (id)getQueue
{
    if ([self isEmpty]) {
        return nil;
    }
    
    id value = _queue.firstObject;
    [_queue removeObjectAtIndex:0];
    return value;
}
- (BOOL)isEmpty
{
    return _queue.count == 0;
}
- (void)clean
{
    [_queue removeAllObjects];
}
@end

@interface GACMatcherProcessor ()
{
    GACQueue * _queue;
    GACNode * _root;
}
@end

@implementation GACMatcherProcessor

- (instancetype)init
{
    self = [super init];
    if (self) {
        _root = [[GACNode alloc] init];
        _queue = [[GACQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self destroy];
}

- (void)insertString:(NSString *)aString userInfo:(id)info
{
    GACNode *p = _root;
    
    unsigned long length = [aString length];
    
    for (int i = 0; i < length; ++i) {
        NSString *temp = [aString substringWithRange:NSMakeRange(i,1)];
        GACNode * node = [p.next objectForKey:temp];
        if (!node) {
            GACNode *newNode = [[GACNode alloc] init];
            [p.next setObject:newNode forKey:temp];
            node = newNode;
        }
        p = node;
    }
    p.storeString = aString;
    if (info) {
        p.userInfo = info;
    }
}

- (void)insertString:(NSString*)aString
{
    [self insertString:aString userInfo:nil];
}


- (void)insertStrings:(NSArray<NSString*>*)strings
{
    [strings enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            [self insertString:obj userInfo:nil];
        } else if ([obj respondsToSelector:NSSelectorFromString(@"getPatternString")]) {
            NSString * pattern = [obj performSelector:NSSelectorFromString(@"getPatternString")];
            [self insertString:pattern userInfo:obj];
        }
    }];
}

- (NSArray*)searchString:(NSString*)searchStr
{
    NSMutableArray * result = [NSMutableArray array];
    GACNode *p = _root;
    unsigned long length = [searchStr length];
    
    for (int i= 0; i < length; i++) {
        NSString *temp = [searchStr substringWithRange:NSMakeRange(i, 1)];
        GACNode *node = [p.next objectForKey:temp];
        
        while (!node && p != _root) {
            p = p.failed;
            node = [p.next objectForKey:temp];
        }
        p = node;
        
        if (!p) {
            p = _root;
        }
        GACNode *tempNew = p;
        while (tempNew != _root) {
            if (tempNew.storeString) {
                [result addObject:[GMatcherResult result:tempNew.storeString location:i-tempNew.storeString.length + 1 userInfo:tempNew.userInfo]];
            } 
            tempNew = tempNew.failed;
        }
    }
    return result;
}

- (void)build
{
    [self buildFailPointer];
}

- (void)destroy
{
    [_queue clean];
    [_queue addQueue:_root];
    while (![_queue isEmpty]) {
        
        GACNode *temp = [_queue getQueue];
        [temp.next enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GACNode * _Nonnull obj, BOOL * _Nonnull stop) {
            
            obj.failed = nil;
            [_queue addQueue:obj];
        }];
    }
}

#pragma --mark private

- (void)buildFailPointer
{
    [_queue clean];
    [_queue addQueue:_root];
    while (![_queue isEmpty]) {
        GACNode *temp = [_queue getQueue];
        
        [temp.next enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GACNode * _Nonnull obj, BOOL * _Nonnull stop) {
            GACNode *p;
            
            if (temp == _root) {
                obj.failed = _root;
            } else {
                p = temp.failed;
                
                while (p) {
                    GACNode *nextNode = [p.next objectForKey:key];
                    if (nextNode) {
                        obj.failed = nextNode;
                        break;
                    }
                    p = p.failed;
                }
            }
            
            if (!p) {
                obj.failed = _root;
            }
            [_queue addQueue:obj];
        }];
    }
}

#pragma mark - protocol Method

- (void)matcherExpressionWithPatterns:(NSArray*)patterns
{
    [self insertStrings:patterns];
    [self build];
}

- (NSArray<GMatcherResult *> *)matchesInString:(NSString *)string
{
    return [self searchString:string];;
}

- (void)enumerateMatchesInString:(NSString *)string usingBlock:(void (NS_NOESCAPE ^)(GMatcherResult * result, BOOL *stop))block
{
    GACNode *p = _root;
    unsigned long length = [string length];
    
    for (int i= 0; i < length; i++) {
        NSString *temp = [string substringWithRange:NSMakeRange(i, 1)];
        GACNode *node = [p.next objectForKey:temp];
        
        while (!node && p != _root) {
            p = p.failed;
            node = [p.next objectForKey:temp];
        }
        p = node;
        
        if (!p) {
            p = _root;
        }
        BOOL hasStop = NO;
        GACNode *tempNew = p;
        while (tempNew != _root) {
            if (tempNew.storeString) {
                GMatcherResult *result = [GMatcherResult result:tempNew.storeString location:i-tempNew.storeString.length + 1 userInfo:tempNew.userInfo];
                if (block) {
                    BOOL hasBreak = NO;
                    block(result,&hasBreak);
                    if (hasBreak) {
                        hasStop = YES;
                        break;
                    }
                }
            }
            tempNew = tempNew.failed;
        }
        if (hasStop) {
            break;
        }
    }
}

@end
