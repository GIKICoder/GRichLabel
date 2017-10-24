//
//  GTagFlowCell.m
//  GBigbangExample
//
//  Created by GIKI on 2017/10/13.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTagFlowCell.h"
#import "GTagFlowLayout.h"

@interface GTagFlowCell()
@property (nonatomic, strong) UILabel * tagLabel;

@end

@implementation GTagFlowCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:({
            _tagLabel = [UILabel new];
            _tagLabel.textColor = [UIColor grayColor];
            _tagLabel.font = [UIFont systemFontOfSize:12];
            _tagLabel.textAlignment = NSTextAlignmentCenter;
            _tagLabel;
        })];
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tagLabel.frame = self.bounds;
}

- (void)configFlowLayout:(GTagFlowLayout*)flowLayout
{
    if (flowLayout.isSelected) {
        if (flowLayout.appearance.selectTextColor) {
            _tagLabel.textColor = flowLayout.appearance.selectTextColor;
        }
        if (flowLayout.appearance.selectBackgroundColor) {
             _tagLabel.backgroundColor = flowLayout.appearance.selectBackgroundColor;
        }
        if (flowLayout.appearance.textFont) {
            _tagLabel.font = flowLayout.appearance.textFont;
        }
        _tagLabel.text = flowLayout.text;
        self.layer.cornerRadius = flowLayout.appearance.cornerRadius;
        self.layer.masksToBounds = YES;
        if (flowLayout.appearance.borderWidth) {
            _tagLabel.layer.borderWidth = flowLayout.appearance.borderWidth;
            _tagLabel.layer.borderColor = flowLayout.appearance.selectBorderColor.CGColor;
        }

        _tagLabel.layer.cornerRadius = flowLayout.appearance.cornerRadius;
        _tagLabel.layer.masksToBounds = YES;
    } else {
        _tagLabel.textColor = flowLayout.appearance.textColor;
        _tagLabel.font = flowLayout.appearance.textFont;
        _tagLabel.backgroundColor = flowLayout.appearance.backgroundColor;
        _tagLabel.text = flowLayout.text;
        
        _tagLabel.layer.borderWidth = flowLayout.appearance.borderWidth;
        _tagLabel.layer.borderColor = flowLayout.appearance.borderColor.CGColor;
        
        self.layer.cornerRadius = flowLayout.appearance.cornerRadius;
        self.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = flowLayout.appearance.cornerRadius;
        _tagLabel.layer.masksToBounds = YES;
    }
}
@end
