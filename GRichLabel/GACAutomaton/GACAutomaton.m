//
//  GACAutomaton.m
//  GRichText
//
//  Created by GIKI on 2017/8/28.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GACAutomaton.h"
#import "GACNode.h"
#import "GACQueue.h"
#import "GACResult.h"

@interface GACAutomaton ()
{
    GACQueue * _queue;
    GACNode * _root;
}
@end

@implementation GACAutomaton

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
    [strings enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertString:obj];
    }];
}

- (void)insertObjects:(NSArray<id<GACObjectProtocol>> *)objects
{
    [objects enumerateObjectsUsingBlock:^(id<GACObjectProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self insertString:[obj getKeyString] userInfo:obj];
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
                [result addObject:[GACResult result:tempNew.storeString location:i-tempNew.storeString.length + 1 userInfo:tempNew.userInfo]];
            } else {
                break;
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

@end
