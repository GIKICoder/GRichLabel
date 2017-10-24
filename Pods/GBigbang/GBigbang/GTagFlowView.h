//
//  GTagFlowView.h
//  GBigbangExample
//
//  Created by GIKI on 2017/10/13.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTagFlowLayout.h"

typedef void(^GTagFlowViewHeightChanged) (CGFloat original,CGFloat newHeight);
typedef void(^GTagFlowViewSelectedChanged) (BOOL hasSelected);

@interface GTagFlowView : UIView

@property (nonatomic, strong) UICollectionView * collectionView;
/// 标签行间距 Default:10.f
@property (nonatomic, assign) CGFloat lineSpacing;

/// 标签间距 Default:4.f
@property (nonatomic, assign) CGFloat interitemSpacing;

/// collectionView EdgeInsets
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

/// 是否支持滑动选择 Default:YES
@property (nonatomic, assign) BOOL  supportSlideSelection;

/// 分词数组
@property (nonatomic, strong ) NSArray<GTagFlowLayout*> * flowDatas;

/// collectionView 高度改变回调
@property (nonatomic, copy  ) GTagFlowViewHeightChanged  heightChangedBlock;

/// 是否有选中词状态改变回调
@property (nonatomic, copy  ) GTagFlowViewSelectedChanged  selectedChangedBlock;

- (void)reloadDatas;

/**
 获取选择词/数组

 @param addingOrder 是否按照选择词顺序生成新词
 @return 新字符串
 */
- (NSString*)getNewTextOrderByAdding:(BOOL)addingOrder;
- (NSArray *)filterAllSelectTitlesOrderByAdding:(BOOL)addingOrder;

/// 按照原有排序生成新字符串
- (NSString*)getNewTextstring;
- (NSArray *)filterAllSelectTitles;
- (NSArray *)filterNoSelectTitles;

@end
