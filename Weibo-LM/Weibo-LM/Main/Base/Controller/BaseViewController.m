//
//  BaseViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "BaseViewController.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ThemeImageView *themeImageView = [[ThemeImageView alloc]initWithFrame:self.view.bounds];
    themeImageView.imageName = @"bg_home.jpg";
    [self.view insertSubview:themeImageView atIndex:0];
    
    [self createBackButton];
    // Do any additional setup after loading the view.
}

-(void)createBackButton{
    NSInteger viewControllerCount = self.navigationController.viewControllers.count;
    
    if (viewControllerCount == 1) {
        return;
    }
    
    ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 44);
    button.backgroundImageName = @"titlebar_button_back_9.png";
    
    [button setTitle:@"返回" forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(buttonBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
}

-(void)buttonBackAction{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
