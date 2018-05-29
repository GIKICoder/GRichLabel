//
//  GRichLabel+TextMenuConfiguration.h
//  GRichLabelExample
//
//  Created by GIKI on 2018/5/29.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "GRichLabel.h"
#import "GMenuContextProtocol.h"

@interface GRichLabelWeakReference : NSObject
@property (nonatomic,   weak) id weakObj;
+ (instancetype)weakReference:(id)weakObj;
@end

@interface GRichLabel (TextMenuConfiguration) <GMenuContextProtocol>

@end
