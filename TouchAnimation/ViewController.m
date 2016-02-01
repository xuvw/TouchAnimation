//
//  ViewController.m
//  TouchAnimation
//
//  Created by heke on 29/1/16.
//  Copyright © 2016年 mhk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];//[UIColor colorWithRed:0.1 green:0.2 blue:0.2 alpha:1];
    
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(10, 30, 100, 100)];
    animationView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:animationView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor grayColor];
    btn.frame = CGRectMake(10, 150, 100, 100);
    [self.view addSubview:btn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 30, 100, 100)];
    imageView.backgroundColor = [UIColor grayColor];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
