//
//  novelReadViewController.m
//  GRichTextExample
//
//  Created by GIKI on 2017/9/15.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "novelReadViewController.h"
#import "GRichLabel.h"
#import "DemoTextMenuConfig.h"
@interface novelReadViewController ()
@property (nonatomic, strong) UIImageView * backgroundImage;
@property (nonatomic, strong) GRichLabel * richLabel;
@end

@implementation novelReadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:({
        _backgroundImage = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:@"novelbg"];
        _backgroundImage.image = image;
        _backgroundImage;
    })];
    
    [self.view addSubview:({
        _richLabel = [[GRichLabel alloc] init];
        _richLabel.canSelect = YES;
        _richLabel.menuConfiguration = [DemoTextMenuConfig new];
        _richLabel;
    })];
    _backgroundImage.frame = self.view.bounds;
    _richLabel.frame = CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height-80);//self.view.frame.size.height-64
    [self setrichContent];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


- (void)setrichContent
{
    GAttributedConfiguration *layout = [GAttributedConfiguration new];
    layout.text = [self content];
    layout.linespace = 3;
    layout.textAlignment = kCTTextAlignmentJustified;
    layout.font = [UIFont systemFontOfSize:16];
    layout.textColor = [UIColor blackColor];
    layout.lineIndent = 2;
    NSAttributedString *config = [GAttributedStringFactory createAttributedStringWithAttributedConfig:layout];
    GDrawTextBuilder *buider = [GDrawTextBuilder buildDrawTextSize:self.richLabel.frame.size insert:UIEdgeInsetsMake(20, 20,10, 20) attributedString:config];
    self.richLabel.textBuilder = buider;//[GAttributedStringFactory createDrawTextBuilderWithAttributedConfig:layout boundSize:CGSizeMake(self.richLabel.frame.size.width, self.richLabel.frame.size.height)];
}

- (NSString*)content {

    return @"第1章[哭笑不得]\n时间定格[哭笑不得]在2009年5月12日凌晨两点，地点为上京市，国家心脏外的一处荒郊\n七辆黑色轿车在荒郊上极速的行驶着，两辆在前，两辆在后，两辆靠在两侧，护着中间的一辆黑色奔驰。军用的大功效引擎发出流畅的声响，车身完全由高性能铝合金所造，挡风玻璃上隐隐可看到呈螺旋状的防弹图痕，没有车牌照，没有特殊军用标识，不禁让人怀疑，这样的车队是怎样从那座森严的首都大门里走出来的。　\n一个小时之后，车队驶进了城郊一处并不起眼的土黄色建筑，四名身着迷彩服的士兵走上前来，示意车上的人停车接受检查，前方的一辆车门打开，身穿黑色西装的年轻人下了车，递过一张深红色的牌子，士兵检查了半晌，沉声说道：“我需要向上级请示。”\n男人眉梢一挑，口气急迫，微微带着丝怒气，压低声音说道：“这上面有华司令的签字，你还需要向什么人请示？”\n士兵面无表情的继续说道：“少校，上级刚刚下达命令，除了首长本人亲至，其他人进入军事禁地一律需要华司令和张参谋长两人的共同署名，否则一律不予放行。”\n“你……”\n“李阳。”\n一个低沉的声音突然从身后的车内响起，黑色奔驰缓缓开上前来，司机摇下车窗，露出里面一张略略有些疲倦的苍老面孔，士兵看了一惊，猛地立正站好，敬了一个军礼，说道：“首长好！”\n华司令淡淡点了点头：“现在我们可以进去了吧？”\n士兵微微有些迟疑，说道：“报告首长，张参谋长命令说军事禁区内不得行车，一律步行。”\n华司令眉头轻轻皱起，拍了拍自己的腿，说道：“我也需要步行？";

}


@end
