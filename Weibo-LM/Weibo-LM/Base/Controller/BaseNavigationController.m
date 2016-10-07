//
//  BaseNavigationController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/4.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (kSystemVersion >= 7.0) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"mask_titlebar64@2x"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"mask_titlebar@2x"] forBarMetrics:UIBarMetricsDefault];
    }
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:22],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]
                                 };
    self.navigationBar.titleTextAttributes = attributes;
    // Do any additional setup after loading the view.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
