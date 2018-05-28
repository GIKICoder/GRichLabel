//
//  ChatTableViewCell.h
//  GRichLabelExample
//
//  Created by GIKI on 2018/5/28.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRichLabel.h"

@interface ChatTableViewCell : UITableViewCell
- (void)configTextBuilder:(GDrawTextBuilder*)textBuilder;
@property (nonatomic,   weak) UITableView   *weakTableView;
@end
