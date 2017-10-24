//
//  GAdjustButton.m
//  GMenuController
//
//  Created by GIKI on 2017/10/19.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GAdjustButton.h"

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}
/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

@implementation GAdjustButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }
    
    if (self.imagePosition == GAdjustButtonIMGPositionLeft) {
        return;
    }
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(self.bounds) - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), CGRectGetHeight(self.bounds) - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets));
    
    if (self.imagePosition == GAdjustButtonIMGPositionTop || self.imagePosition == GAdjustButtonIMGPositionBottom) {
        
        CGFloat imageLimitWidth = contentSize.width - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(imageLimitWidth, CGFLOAT_MAX)];// 假设图片高度必定完整显示
        CGRect imageFrame = (CGRect){{0,0},imageSize};
        
        CGSize titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) - imageSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.width = fminf(titleSize.width, self.frame.size.width);
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        CGRect titleFrame = (CGRect){{0,0},titleSize};
        
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                imageFrame.origin.x =  self.contentEdgeInsets.left + self.imageEdgeInsets.left;
                titleFrame.origin.x  = self.contentEdgeInsets.left + self.titleEdgeInsets.left;
                break;
            case UIControlContentHorizontalAlignmentCenter:
                imageFrame.origin.x =self.contentEdgeInsets.left + self.imageEdgeInsets.left + (imageLimitWidth - imageSize.width)/2;
                titleFrame.origin.x =self.contentEdgeInsets.left + self.titleEdgeInsets.left + (titleLimitSize.width- titleSize.width)/2;
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame.origin.x  = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - imageSize.width;
                titleFrame.origin.x  = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.titleEdgeInsets.right - titleSize.width;
                break;
            case UIControlContentHorizontalAlignmentFill:
                imageFrame.origin.x = self.contentEdgeInsets.left + self.imageEdgeInsets.left;
                imageFrame.size.width =imageLimitWidth;
                titleFrame.origin.x = self.contentEdgeInsets.left + self.titleEdgeInsets.left;
                titleFrame.size.width = titleLimitSize.width;
                break;
        }
        
        if (self.imagePosition == GAdjustButtonIMGPositionTop) {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    imageFrame.origin.y =  self.contentEdgeInsets.top + self.imageEdgeInsets.top;
                    titleFrame.origin.y = CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets) + CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets);
                    CGFloat minY = (contentSize.height - contentHeight)/2.0 + self.contentEdgeInsets.top;
                    imageFrame.origin.y = minY + self.imageEdgeInsets.top;
                    titleFrame.origin.y = CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    titleFrame.origin.y = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame);
                    imageFrame.origin.y =  CGRectGetMinY(titleFrame) - self.titleEdgeInsets.top - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame);
                    break;
                case UIControlContentVerticalAlignmentFill:
                    // 图片按自身大小显示，剩余空间由标题占满
                    imageFrame.origin.y = self.contentEdgeInsets.top + self.imageEdgeInsets.top;
                    titleFrame.origin.y = CGRectGetMaxY(imageFrame) + self.imageEdgeInsets.bottom + self.titleEdgeInsets.top;
                    titleFrame.size.height = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame);
                    break;
            }
        } else {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentTop:
                    titleFrame.origin.y = self.contentEdgeInsets.top + self.titleEdgeInsets.top;
                    imageFrame.origin.y = CGRectGetMaxY(titleFrame) + self.titleEdgeInsets.bottom + self.imageEdgeInsets.top;
                    break;
                case UIControlContentVerticalAlignmentCenter: {
                    CGFloat contentHeight = CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets) + CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
                    CGFloat minY = (contentSize.height- contentHeight)/2.0 + self.contentEdgeInsets.top;
                    titleFrame.origin.y =  minY + self.titleEdgeInsets.top;
                    imageFrame.origin.y = CGRectGetMaxY(titleFrame) + self.titleEdgeInsets.bottom + self.imageEdgeInsets.top;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom:
                    imageFrame.origin.y = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame);
                    titleFrame.origin.y =  CGRectGetMinY(imageFrame) - self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame);
                    
                    break;
                case UIControlContentVerticalAlignmentFill:
                    // 图片按自身大小显示，剩余空间由标题占满
                    imageFrame.origin.y = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame);
                    titleFrame.origin.y = self.contentEdgeInsets.top + self.titleEdgeInsets.top;
                    titleFrame.size.height
                    = CGRectGetMinY(imageFrame) - self.imageEdgeInsets.top - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame);
                    break;
            }
        }
        
        self.imageView.frame = imageFrame;
        self.titleLabel.frame = titleFrame;
        
    } else if (self.imagePosition == GAdjustButtonIMGPositionRight) {
        
        CGFloat imageLimitHeight = contentSize.height - UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets);
        CGSize imageSize = [self.imageView sizeThatFits:CGSizeMake(CGFLOAT_MAX, imageLimitHeight)];// 假设图片宽度必定完整显示，高度不超过按钮内容
        CGRect imageFrame = (CGRect){{0,0},imageSize};
        
        CGSize titleLimitSize = CGSizeMake(contentSize.width - UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) - CGRectGetWidth(imageFrame) - UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets), contentSize.height - UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets));
        CGSize titleSize = [self.titleLabel sizeThatFits:titleLimitSize];
        titleSize.height = fminf(titleSize.height, titleLimitSize.height);
        titleSize.width = fminf(titleLimitSize.width, titleSize.width);
        CGRect titleFrame = (CGRect){{0,0},titleSize};
        
        switch (self.contentHorizontalAlignment) {
            case UIControlContentHorizontalAlignmentLeft:
                titleFrame.origin.x =  self.contentEdgeInsets.left + self.titleEdgeInsets.left;
                imageFrame.origin.x  = CGRectGetMaxX(titleFrame) + self.titleEdgeInsets.right + self.imageEdgeInsets.left;
                break;
            case UIControlContentHorizontalAlignmentCenter: {
                CGFloat contentWidth = CGRectGetWidth(titleFrame) + UIEdgeInsetsGetHorizontalValue(self.titleEdgeInsets) + CGRectGetWidth(imageFrame) + UIEdgeInsetsGetHorizontalValue(self.imageEdgeInsets);
                CGFloat minX = self.contentEdgeInsets.left + (contentSize.width- contentWidth)/2;
                titleFrame.origin.x = minX + self.titleEdgeInsets.left;
                imageFrame.origin.x =  CGRectGetMaxX(titleFrame) + self.titleEdgeInsets.right + self.imageEdgeInsets.left;
            }
                break;
            case UIControlContentHorizontalAlignmentRight:
                imageFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame);
                titleFrame.origin.x =CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.titleEdgeInsets.right - CGRectGetWidth(titleFrame);
                break;
            case UIControlContentHorizontalAlignmentFill:
                // 图片按自身大小显示，剩余空间由标题占满
                imageFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - self.imageEdgeInsets.right - CGRectGetWidth(imageFrame);
                titleFrame.origin.x = self.contentEdgeInsets.left + self.titleEdgeInsets.left;
                titleFrame.size.width =  CGRectGetMinX(imageFrame) - self.imageEdgeInsets.left - self.titleEdgeInsets.right - CGRectGetMinX(titleFrame);
                break;
        }
        
        switch (self.contentVerticalAlignment) {
            case UIControlContentVerticalAlignmentTop:
                titleFrame.origin.y = self.contentEdgeInsets.top + self.titleEdgeInsets.top;
                imageFrame.origin.y = self.contentEdgeInsets.top + self.imageEdgeInsets.top;
                break;
            case UIControlContentVerticalAlignmentCenter:
                titleFrame.origin.y = self.contentEdgeInsets.top + self.titleEdgeInsets.top + (contentSize.height - (CGRectGetHeight(titleFrame) + UIEdgeInsetsGetVerticalValue(self.titleEdgeInsets)))/2;
                imageFrame.origin.y = self.contentEdgeInsets.top + self.imageEdgeInsets.top + (contentSize.height- (CGRectGetHeight(imageFrame) + UIEdgeInsetsGetVerticalValue(self.imageEdgeInsets)))/2;
                break;
            case UIControlContentVerticalAlignmentBottom:
                titleFrame.origin.y = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetHeight(titleFrame);
                imageFrame.origin.y = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetHeight(imageFrame);
                break;
            case UIControlContentVerticalAlignmentFill:
                titleFrame.origin.y = self.contentEdgeInsets.top + self.titleEdgeInsets.top;
                titleFrame.size.height = CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.titleEdgeInsets.bottom - CGRectGetMinY(titleFrame);
                imageFrame.origin.y = self.contentEdgeInsets.top + self.imageEdgeInsets.top;
                imageFrame.size.height =  CGRectGetHeight(self.bounds) - self.contentEdgeInsets.bottom - self.imageEdgeInsets.bottom - CGRectGetMinY(imageFrame);
                break;
        }
        
        self.imageView.frame = imageFrame;
        self.titleLabel.frame = titleFrame;
    }
}

- (void)setImagePosition:(GAdjustButtonIMGPosition)imagePosition
{
    _imagePosition = imagePosition;
    [self setNeedsLayout];
}
@end
