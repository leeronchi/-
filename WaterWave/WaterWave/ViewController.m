//
//  ViewController.m
//  WaterWave
//
//  Created by snapking on 16/1/6.
//  Copyright © 2016年 snapking. All rights reserved.
//

#import "ViewController.h"
#import "WaterView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CGFloat main_width = [[UIScreen mainScreen] bounds].size.width;

    
    WaterView *v=[[WaterView alloc] initWithFrame:CGRectMake(0, 130, main_width, 70)];
    [self.view addSubview:v];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
