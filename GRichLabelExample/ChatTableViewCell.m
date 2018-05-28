//
//  ChatTableViewCell.m
//  GRichLabelExample
//
//  Created by GIKI on 2018/5/28.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "ChatTableViewCell.h"

#define GColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define GColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
// 随机色
#define GRandomColor GColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
@interface ChatTableViewCell()
@property (nonatomic, strong) UIImageView * avatarView;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIView * cardView;
@property (nonatomic, strong) GRichLabel * richLabel;
@property (nonatomic, strong) GDrawTextBuilder * textBuilder;
@end
@implementation ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:({
            _avatarView = [[UIImageView alloc] init];
            _avatarView.layer.cornerRadius = 18;
            _avatarView.layer.masksToBounds = YES;
            _avatarView.backgroundColor = GRandomColor;
            _avatarView;
        })];
        [self.contentView addSubview:({
            _nameLabel = [UILabel new];
            _nameLabel.text = @"GIKI";
            _nameLabel.font = [UIFont systemFontOfSize:16];
            _nameLabel.textColor = [UIColor blackColor];
            _nameLabel;
        })];
        [self.contentView addSubview:({
            _cardView = [UIView new];
            _cardView.backgroundColor =GColor(175,228,110);
            _cardView.layer.cornerRadius = 4;
            _cardView;
        })];
        [self.cardView addSubview:({
            _richLabel = [[GRichLabel alloc] init];
            _richLabel.canSelect = YES;
            _richLabel.displaysAsynchronously = YES;
            _richLabel.cursorColor = GColor(70, 142, 47);
            _richLabel.selectionColor = GColorRGBA(34, 139, 34,1);
            _richLabel;
        })];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.avatarView.frame = CGRectMake(12, 12, 36, 36);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarView.frame)+16, 12+18-11, 200, 22);
    self.cardView.frame = CGRectMake(12+36, CGRectGetMaxY(self.nameLabel.frame) + 12, self.textBuilder.boundSize.width+16, self.textBuilder.boundSize.height+16);
    self.richLabel.frame = CGRectMake(8, 8, self.textBuilder.boundSize.width, self.textBuilder.boundSize.height);
    
}

- (void)configTextBuilder:(GDrawTextBuilder*)textBuilder
{
    [self.richLabel resetSelection];
    self.avatarView.backgroundColor = GRandomColor;
    self.textBuilder = textBuilder;
    self.richLabel.textBuilder = textBuilder;
}

- (void)setWeakTableView:(UITableView *)weakTableView
{
    self.richLabel.contentScrollView = weakTableView;
}

+ (CGFloat)getTextHeight:(GDrawTextBuilder*)textBuilder
{
    return 0;
}
@end
