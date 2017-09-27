//
//  ViewController.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/7.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "ViewController.h"
#import "LabelViewController.h"
#import "novelReadViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)richLabel:(id)sender
{
    [self gotoViewController:1];
}
- (IBAction)SelectRichLabel:(id)sender
{
    [self gotoViewController:2];
}

- (void)gotoViewController:(int)type
{
    LabelViewController *vc = [[LabelViewController alloc] initLabel:type];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)novelReader:(id)sender {
    novelReadViewController *vc = [[novelReadViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
