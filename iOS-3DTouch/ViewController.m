//
//  ViewController.m
//  iOS-3DTouch
//
//  Created by xiaoming han on 16/10/26.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "ViewController.h"
#import "ForceTouchViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"3D Touch Demo";
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [showButton setTitle:@"显示3DTouch示例" forState:UIControlStateNormal];
    showButton.frame = CGRectMake(0, 0, 200, 40);
    showButton.center = self.view.center;
    
    [showButton addTarget:self action:@selector(actionShow) forControlEvents:UIControlEventTouchUpInside];
    showButton.backgroundColor = [UIColor whiteColor];
    [showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.view addSubview:showButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionShow
{
    ForceTouchViewController *vc = [[ForceTouchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
