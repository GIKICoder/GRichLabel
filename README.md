# GRichLabel
A rich Label that supports selection, copying.

<img src="https://github.com/GIKICoder/GRichLabel/blob/master/screenshot/selectCopy.png" width="400">


Usage
==============

### 1
```
  GRichLabel *richLabel = [GRichLabel new];
  richLabel.frame = CGRectMake(5, 0, self.view.frame.size.width-10, 500);
  richLabel.text = @"xxxxxx";
```
### 2
```
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

Thanks
==============
 [YYText](https://github.com/ibireme/YYText)
