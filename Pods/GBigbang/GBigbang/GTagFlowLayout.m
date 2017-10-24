//
//  GTagFlowLayout.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/13.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#define GTagColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "GTagFlowLayout.h"

@implementation GTagFlowAppearance
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerRadius = 4;
        self.textColor = GTagColor(71, 71, 71);
        self.backgroundColor = [UIColor whiteColor];
        self.selectTextColor = GTagColor(252, 253, 255);
        self.selectBackgroundColor = GTagColor(74, 150, 247);
        
        self.borderWidth = 0;
        self.borderColor = [UIColor redColor];
        self.selectBorderColor = [UIColor blackColor];
        
        self.textFont = [UIFont systemFontOfSize:12];
        self.itemHeight = 30;
        
    }
    return self;
}
@end

@implementation GTagFlowLayout

+ (instancetype)tagFlowLayoutWithText:(NSString*)text
{
    GTagFlowLayout *flow = [[GTagFlowLayout alloc] init];
    flow.text = text;
    return flow;
}

+ (instancetype)tagFlowLayoutWithText:(NSString *)text withAppearance:(GTagFlowAppearance *)appearance
{
    GTagFlowLayout *flow = [[GTagFlowLayout alloc] init];
    flow.text = text;
    flow.appearance = appearance;
    return flow;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.appearance = [GTagFlowAppearance new];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self calculateItemSize];
}

- (void)setAppearance:(GTagFlowAppearance *)appearance
{
    if (appearance) {
        _appearance = appearance;
        [self calculateItemSize];
    }
}

- (void)calculateItemSize
{
    if (self.text.length  <= 0 || !self.appearance) {
        return;
    }

    NSDictionary *attributes = @{NSFontAttributeName:self.appearance.textFont};
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    CGSize size = rect.size;
    if (self.appearance.itemHeight > 0) {
        size.height = self.appearance.itemHeight;
    }
    size.width += 18;
    self.itemSize = size;
}

+ (NSArray<GTagFlowLayout*>*)factoryFolwLayoutWithItems:(NSArray<GBigbangItem*>*)items withAppearance:(GTagFlowAppearance*)appearance;
{
    __block NSMutableArray * arrayM = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(GBigbangItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GTagFlowLayout *layout = [GTagFlowLayout tagFlowLayoutWithText:obj.text withAppearance:appearance];
        [arrayM addObject:layout];
    }];
    return arrayM.copy;
}
@end
