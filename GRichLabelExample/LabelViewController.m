//
//  LabelViewController.m
//  GRichText
//
//  Created by GIKI on 2017/8/29.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "LabelViewController.h"

#import "GRichLabel.h"

@interface LabelViewController ()
@property (nonatomic, strong) UIScrollView  *scrollview;
@property (nonatomic, strong) GRichLabel * richLabel;
@property (nonatomic, assign) int  type;
@end

@implementation LabelViewController

- (instancetype)initLabel:(int)type
{
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:({
        _scrollview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollview.backgroundColor =[UIColor clearColor];
        _scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
        _scrollview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _scrollview;
    })];
    
        self.richLabel = [GRichLabel new];
        self.richLabel.frame = CGRectMake(5, 0, self.view.frame.size.width-10, 500);
    
        self.richLabel.contentScrollView = self.scrollview;
        self.richLabel.displaysAsynchronously = YES;
        [self.scrollview addSubview:self.richLabel];
        self.scrollview.scrollEnabled = NO;
        [self setRichText];
    if (self.type == 1) {
        self.richLabel.canCopy = NO;
    } else {
        self.richLabel.canCopy = YES;
    }
}

- (void)setRichText
{

    NSString * content = @"[大便]干杯春天在哪里，太郎太刀❤️/LD1🐶/绿高绿🏀/死于懒癌👻/bigbang👑/TGforever👑[哭笑不得] 春天@在你的眼睛里，oh, my aa god, @冯科:18900126257 @王金yu @巩柯 #郭天池# 春天在他的眼 [干杯aa 睛里，春天在你aa我的眼睛里你的两岸观光进入寒冬，陆客赴bb台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的bb客源，[哭笑不得]锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年de我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少4[哭笑不得26.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称，“台湾观光协会”是由岛内航空公司、观光饭店、@冯科 @王金yu旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。";//[self content];
    __weak typeof(self) weakSelf = self;
    NSString* str =[self richt];
    NSLog(@"content Lenght -- %lu",(unsigned long)str.length);
    GAttributedToken * token = [GAttributedToken new];
    token.textToken = @"@冯科";
   
    GAttributedToken * token1 = [GAttributedToken new];
    token1.textToken = @"@王金yu";
    GAttributedToken * token2 = [GAttributedToken new];
    token2.textToken = @"@巩柯";
    GAttributedToken * token3 = [GAttributedToken new];
    token3.textToken = @"#郭天池#";
    GAttributedToken * token4 = [GAttributedToken new];
    token4.textToken = @"你的你的你的你的的你的你你的你";
    token.tokenClickBlock = ^(GAttributedToken *token) {
         [weakSelf gotoVC:token.textToken];
    };
    token1.tokenClickBlock = ^(GAttributedToken *token) {
         [weakSelf gotoVC:token.textToken];
    };
    token2.tokenClickBlock = ^(GAttributedToken *token) {
     [weakSelf gotoVC:token.textToken];
    };
    token3.tokenClickBlock = ^(GAttributedToken *token) {
        [weakSelf gotoVC:token.textToken];
    };
    token4.tokenClickBlock = ^(GAttributedToken *token) {
        [weakSelf gotoVC:token.textToken];
    };
    NSArray * tokens = @[token,token1,token2,token3,token4];
    
    GAttributedToken *regex = [GAttributedToken new];
    regex.regexToken = Phone;
     GAttributedToken *regex1 = [GAttributedToken new];
    GAttributedStringLayout *layout = [GAttributedStringLayout new];
    layout.text = str;
    layout.tokenPatternConfigs = tokens;
    layout.regexPatternConifgs = @[regex1,regex];
    layout.textAlignment = kCTTextAlignmentJustified;
    layout.linespace = 1;
    layout.lineIndent = 3;
    layout.font = [UIFont systemFontOfSize:14];
    layout.truncationToken = [[NSAttributedString alloc] initWithString:@"...全文"];
    GDrawTextBuilder * builder = [GAttributedStringFactory createDrawTextBuilderWithLayout:layout boundSize:self.richLabel.frame.size];
    self.richLabel.textBuilder = builder;
//    self.richLabel.attributedLayout = layout;;
    
//    self.richLabel.text = content;
}

- (void)gotoVC:(NSString *)string
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = string;
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}


- (NSString  *)richt {

    return @"❤️[哭笑不得]🐶🏀不上陆[大便]@冯科 ，也比不[大便]上陆@冯科 @ @[呕吐]👻👑👑[哭笑不得]🐶不上陆@冯科 @王金yu客减少一个月的量，难以倍，也比不上陆@冯科 @🏀[呕吐]不上陆@冯科 @王金yu客减少一个月的量，难以倍，也比不上陆@冯科 @🐶🏀[吓]🐶@王金yu客减少11🐶[干杯]🐶春天在哪里，🐶[哭笑不得]🐶春/n天@在你的眼睛里，oh, myaa god, @冯科:18900126257 @王金yu @巩柯 #郭天池# 春天在他的眼 [干杯]aa 睛里，春天在你aa我的眼睛里你的两岸观光进入寒冬，陆客赴bb台人数持续缩减。据台湾《经济日报》23日报道，民\n党当局转向冲刺“新南向”的bb客源，[哭笑不得]锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，[大便]积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年de我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少4[哭笑不得]26.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称台湾，“台湾观光协会”是由岛内航空公司、观光饭店、@冯科 @王金yu旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。不过叶菊兰接掌“观光协会”后，虽然表示欢迎陆客来台，但强调不愿意持台胞证赴大陆，让对岸担忧其政治立场。与此同时，叶菊兰虽然表态要委任赖瑟珍继续奔走两岸，但迄今没落实，“形同放弃与陆方打交道、建立关系的机会”。11春天在哪里，春天在你的眼睛里，oh, my god, 春天在他的眼睛里，春天在你我的眼睛里你的两岸观光进入寒冬，陆客赴台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的客源，锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者直言，“新南向一个月的量，难以倍，也比不上陆@冯科不上陆@冯科 @王金yu客减少一个月的量，难以倍🏀❤️[哭笑不得]🐶也比不上🏀[呕吐]👻👑@王金yu客减少一个月的量，难以倍，也比不上陆@冯科不上陆@冯科 @王金yu客减少一个月的量，难以倍👑[哭笑不得]🐶🏀[呕吐]🐶🏀[吓]🐶🏀❤️[哭笑不得]🐶🏀[呕吐]👻👑👑[哭笑不得]🐶🏀[呕吐]🐶🏀[吓]🐶也比不上🏀也比不上❤️也比不上[哭笑不得]🐶🏀也比不上[呕吐]👻也比不上👑👑[哭笑不得]🐶🏀[呕吐]🐶🏀也比不上[吓]🐶也比不上🏀倍，也比不上陆@冯科 @王金11🐶[干杯]🐶春天在哪里，🐶[哭笑不得]🐶春/n天@在你的眼睛里，oh, myaa god, @冯科:18\n900126257 @王金yu @巩柯 #郭天池# 春天在他的眼 [干杯]aa 睛里，春天在你aa我的眼睛里你的两岸观光进入寒冬，陆客赴bb台人数持续缩减。据台湾《经济日报》23日报道，民\n党当局转向冲刺“新南向”的bb客源，[哭笑不得]锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年de我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少4[哭笑不得]26.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称台湾，“台湾观光协会”是由岛内航空公司、观光饭店、@冯科 @王金yu旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。不过叶菊兰接掌“观光协会”后，虽然表示欢迎陆客来台，但强调不愿意持台胞证赴大陆，让对岸担忧其政治立场。与此同时，叶菊兰虽然表态要委任赖瑟珍继续奔走两岸，但迄今没落实，“形同放弃与陆方打交道、建立关系的机会”。11春天在哪里，春天在你的眼睛里，oh, my god, 春天在他的眼睛里，春天在你我的眼睛里你的两岸观光进入寒冬，陆客赴台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的客源，锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者直言，“新南向yu客减少一个月的量，难以倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以";
}


- (NSString *)content{
    
    
    return  @"aa 11🐶[干杯]🐶春天在哪里，🐶[哭笑不得]🐶春/n天@在你的眼睛里，oh, myaa god, @冯科:18\n900126257 @王金yu @巩柯 #郭天池# 春天在他的眼 [干杯]aa 睛里，春天在你aa我的眼睛里你的两岸观光进入寒冬，陆客赴bb台人数持续缩减。据台湾《经济日报》23日报道，民\n党当局转向冲刺“新南向”的bb客源，[哭笑不得]锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年de我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆@冯科 @王金yu客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少4[哭笑不得]26.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称台湾，“台湾观光协会”是由岛内航空公司、观光饭店、@冯科 @王金yu旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。不过叶菊兰接掌“观光协会”后，虽然表示欢迎陆客来台，但强调不愿意持台胞证赴大陆，让对岸担忧其政治立场。与此同时，叶菊兰虽然表态要委任赖瑟珍继续奔走两岸，但迄今没落实，“形同放弃与陆方打交道、建立关系的机会”。11春天在哪里，春天在你的眼睛里，oh, my god, 春天在他的眼睛里，春天在你我的眼睛里你的两岸观光进入寒冬，陆客赴台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的客源，锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者直言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期大减四成。“交通部”官员预估，我今年我陆客来台人数将比去年减少100万人次，台湾将减少426.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，来台人数将比去年减少100万人次，台湾将减少426.5我亿元新台币的观光收入。不少媒体感慨，现在也就只有“九二共识我”和一个中国能挽救台湾观光了。《经济日报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交流盛会也决定不来，“台湾观光协我会在两岸民间交流我中扮我演的地位，可谓一落千丈”。该报我介绍我称，“台湾观光协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任我，《经济日我报》称，两岸关系倒退，反映在观光交流上尤其明显。从今年元宵节开始，大陆就没有参加台湾灯会，7月下旬又缺席台湾美食展，到现在连两岸年度在台最大交我流盛会也决定不来，“台湾观光协会在两岸民间交流中扮演的我地位，可谓一落千丈”。该报介绍称，“台湾观光我协会”是由岛内航空公司、观光饭店、旅馆、旅行社和餐饮业等代表组成，多名会长都是观光局长退休担任，陈水扁当政时期，“观光协会”在两岸观光交流中扮演桥梁角色，马英九开放陆客来台观光后，该协会更成为两岸观光交流位阶最高的民间单位，尤其赖瑟珍担任会长时，多次率领岛内业者赴大陆参访、交流，为两岸观光建立极佳交情我。不过叶菊兰接掌“观光协会”后，虽然表示欢迎陆客来台，但强调不愿意持台胞证赴大陆，让对岸担忧其政治立场。与此同时，叶菊兰虽然表态要委任赖瑟珍继续奔走两岸，但迄今没落实，“形同放弃与陆方打交道、建立关系的机会”。11春天在哪里，春天在你的眼睛里，oh, my god, 春天在他的眼睛里，春天在你我的眼睛里你的两岸观光进入寒冬，陆客赴台人数持续缩减。据台湾《经济日报》23日报道，民进党当局转向冲刺“新南向”的客源，锁定菲律宾、越南、文莱、泰国、印度尼西亚和印度等，积极宣传及放宽来台“签证”措施。统计显示，蔡英文上任前一年我，这些地区来台旅客数为65.我9万人次放宽后这一年增加到96.1万人次，即增加30万人次，约多出77亿元新台币的观光收益。不过观光业者直言，“新南向”的旅客量原本我就少，即使增加一倍，也比不上陆客减少一个月的量，难以弥补陆客大幅缩减造成的观光损失。数据显示，今年上半年，陆客来台人数为126.5万人次，比去年同期.............................，，";
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
