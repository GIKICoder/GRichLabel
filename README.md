# GRichLabel
A rich Label that supports selection, copying.

<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/selectCopy.png" width="400">
<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/novelReader.png" width="400">
<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/chatlist.png" width="400">

Features
==============
- 1,基于coretext绘制文本.内部使用YYAsyncLayer提供异步绘制任务
- 2,支持选择/复制文本.
- 3,支持自定义表情排版
- 4,可自定义文本选择弹出menuView [GMenuContoller](https://github.com/GIKICoder/GMenuController)
- 5,对于文本token 采用多模匹配算法. 详见[GMatcherExpression](https://github.com/GIKICoder/GRichLabel/tree/master/GRichLabel/GMatching).文本匹配效率比系统字符串匹配效率提高百倍.
- 6,功能以及代码还在更新完善中. 后期会支持更多功能.欢迎star.
- 7,支持文本在滚动视图中做文本滚动选择 （微信聊天气泡文本选择）



Usage
==============

### 1
```objc
  GRichLabel *richLabel = [GRichLabel new];
  richLabel.frame = CGRectMake(5, 0, self.view.frame.size.width-10, 500);
  richLabel.text = @"xxxxxx";
```
### 2
```objc
{
self.tokens = @[@"@冯科",@"@王金yu",@"@巩柯",@"#郭天池#"];
GRichLabel *richLabel = [GRichLabel new];
richLabel.frame = CGRectMake(5, 0, self.view.frame.size.width-10, 500);
}

- (void)setRichText
{
    __weak typeof(self) ws = self;
    NSString* string =[self content1];
    __block NSMutableArray *tokens = [NSMutableArray array];
    [self.tokens enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj) *stop = NO;
        GAttributedToken * token = [GAttributedToken attributedTextToken:obj];
        token.tokenClickBlock = ^(GAttributedToken *token) {
            [ws gotoVC:token.textToken];
        };
        [tokens addObject:token];
    }];
    GAttributedToken *regex = [GAttributedToken new];
    regex.regexToken = Phone;
    regex.tokenClickBlock = ^(GAttributedToken *token) {

    };
    GAttributedStringLayout *layout = [GAttributedStringLayout attributedLayout:string];
    layout.tokenPatternConfigs = tokens.copy;
    layout.regexPatternConifgs = @[regex];
    layout.textAlignment = kCTTextAlignmentJustified;
    layout.linespace = 1;
    layout.lineIndent = 2;
    layout.font = [UIFont systemFontOfSize:14];

    NSMutableAttributedString * truncation = [[NSMutableAttributedString alloc] initWithString:@"...全文"];

    layout.truncationToken = truncation;
    GDrawTextBuilder * builder = [GAttributedStringFactory createDrawTextBuilderWithLayout:layout boundSize:self.richLabel.frame.size];
    self.richLabel.textBuilder = builder;
  
}
  
```

Installation
==============

- 手动添加
1. ` git clone  https://github.com/GIKICoder/GRichLabel.git `
2. 选择`GRichLabel`文件夹.拖入项目中.
3. `GRichLabel` 依赖 `GMenuController https://github.com/GIKICoder/GMenuController`,  `YYAsyncLayer https://github.com/ibireme/YYAsyncLayer` 这2个库. 可以使用pod添加. 也可下载手动添加到项目

update Info
==============
- 29/10/2017 代码重构.处理耦合逻辑.简化代码.重新整理NSAttributedString分类(参考NSAttributedString+YYText[YYText](https://github.com/ibireme/YYText)).使GRichLabel具有更强大的文本处理能力.
- 06/12/2017 增加kGAttributeTokenReplaceStringName. 支持自定义表情 链接等字符串copy 处理.
- 19/04/2018 增加GMatherExpression 增加字符匹配模式.
- 27/08/2018 增加文本选择模式，在滚动视图下可支持滚动文本选择。

 
