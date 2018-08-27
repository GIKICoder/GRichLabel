//
//  ChatViewController.m
//  GRichLabelExample
//
//  Created by GIKI on 2018/5/28.
//  Copyright © 2018年 GIKI. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatTableViewCell.h"

@interface ChatViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * texts;
@property (nonatomic, strong) NSArray * datas;
@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [self loadData];
    [self loadUI];
}

- (void)loadUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame));
}

#pragma mark -- TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell"];
    if (!cell) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    }
    GDrawTextBuilder * builder = self.datas[indexPath.row];
    cell.weakTableView = self.tableView;
    [cell configTextBuilder:builder];
    return cell;
}


#pragma mark -- TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDrawTextBuilder * builder = self.datas[indexPath.row];
    return builder.boundSize.height+80;
}

#pragma mark - loadDatas

- (void)loadData
{
    __block NSMutableArray * arrayM = [NSMutableArray array];
    [self.texts enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GAttributedConfiguration * configuraltion = [GAttributedConfiguration attributedConfig:obj color:[UIColor blackColor] font:[UIFont systemFontOfSize:18]];
        NSAttributedString * attribute = [GAttributedStringFactory createAttributedStringWithAttributedConfig:configuraltion];
        CGSize size = [GAttributedStringFactory getRichLabelDrawSizeWithAttributedString:attribute MaxContianerWidth:self.view.frame.size.width-12-36-12-36];
        GDrawTextBuilder * builder = [GAttributedStringFactory createDrawTextBuilderWithAttributedConfig:configuraltion boundSize:size];
        [arrayM addObject:builder];
    }];
    self.datas = arrayM.copy;
}

- (NSArray *)texts
{
    if (!_texts) {
        _texts =@[@"生态环境风险是未来可能发生的环境问题及其影响后果。生态环境安全是国家安全的重要组成部分，是经济社会持续健康发展的重要保障。生态环境特别是大气、水、土壤污染严重",
                  @"我国自然生态环境先天不足，整体生态环境系统脆弱。同时，在长期的发展过程中，我们也积累了大量生态环境问题，各类环境污染呈高发态势，逐渐累积的生态风险不容忽视。一方面，资源短缺。",
                  @"《2016中国环境状况公报》",
                  @"😀😄😂😌🤩☹️😳😡🤬🇦🇪🏸🏐🚒🚄🛫✈️🚉🚂🚝☮️✝️☪️⚂♞♤☆",
                  @"😀😄😂😌土壤污染潜在风险不断累😀😄😂😌积。部分地区土壤污染较重，耕地土壤环境质量堪忧，工矿业废弃地土壤环境问题突出。",
                  @"生态环境风险防范是一个系统和完整的体系。生态环境风险具有高度的多样性和复杂性。其表现形式十分复杂：大气污染、水污染、土壤污染、水土流失、自然灾害、荒漠化、生态系统退化、海洋环境问题、新型污染物、农村环境问题、气候变化、环境污染事故、环境社会性群体事件等都有关系。同时，造成这些问题的来源也十分复杂：工农业生产、资源开发、城乡居民生活、物流交换、国内外贸易等都相关。这些活动所涉及的主体也非常多：各级决策者、生产企业、社会大众、资源开发者等都涉及。因此，生态环境风险防范必将是一个系统和完整的体系。《中共中央关于全面深化改革若干重大问题的决定》提出：建设生态文明，必须建立系统完整的生态文明制度体系，实行最严格的源头保护制度、损害赔偿制度、责任追究制度，完善环境治理和生态修复制度，用制度保护生态环境。习近平指出：“要把生态环境风险纳入常态化管理，系统构建全过程、多层级生态环境风险防范体系。",
                  @"构建多元共治的治理体系。从中央到地方，从主管部门到民间🚂🚝环保组织，从企业到个人，生态环境治理不🏐🚒🚄🛫仅仅是各级党政领导干部工作中最重要的组成部分，更应深入到每个人日常生活的点点滴滴中。政府应当让🏐🚒🚄🛫企业和公众广泛参与进来，强化企业防治污染的主体责任，让其主动承担防治责任；调动群众的积极性，保障他们的话语权，群策群力，共治共享，形成环境共治模式。\n　　扭转环境恶化、提高环境质量是广大人民群众的热切期盼。要系统构建全过程、多层级生态环境风险防范体系，解决生态问题，规避环境风险，保证美丽中国的愿景充分实现。🏸✈️🚉",
                  @"　过去几天，在杭州西北部郊区的很多银行出现了这样的场景：有人晕倒，有人打架，办理业务的长队排出1公里……\n他们都是去冻结银行存款、登记摇号买房。而其中大部分人的目标是华夏四季和融信澜天这两个楼盘。"];
    }
    return _texts;
}

@end
