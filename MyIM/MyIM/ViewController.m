//
//  ViewController.m
//  MyIM
//
//  Created by Jonathan on 15/8/10.
//  Copyright (c) 2015年 Jonathan. All rights reserved.
//

#import "ViewController.h"
#import "MyChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MyChatViewController *chatController = [[MyChatViewController alloc] initWithNib];
    chatController.title = @"对话";
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chatController];
    [self addChildViewController:nav];
    nav.view.bounds = self.view.bounds;
    [self.view addSubview:nav.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
