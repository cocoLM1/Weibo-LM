//
//  RightViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/22.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "RightViewController.h"
#import "SendWeiboViewController.h"
#import "BaseNavigationController.h"
#import "UIViewController+MMDrawerController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createButton];
}

-(void)createButton{
    CGFloat buttonWidth = 50;
    CGFloat space = 15;
    
    for (int i = 0; i < 5; i++) {
        CGRect frame = CGRectMake(space, space + (space + buttonWidth) * i, buttonWidth, buttonWidth);
        
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = frame;
        [self.view addSubview:button];
        
        NSString *imageName = [NSString stringWithFormat:@"newbar_icon_%i.png",i+1];
        button.imageName = imageName;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
    }
    
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [mapButton setImage:[UIImage imageNamed:@"btn_map_location"] forState:UIControlStateNormal];
    [self.view addSubview:mapButton];
    
    UIButton *qrButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qrButton.frame = CGRectMake(space, 0, buttonWidth, buttonWidth);
    [qrButton setImage:[UIImage imageNamed:@"qr_btn"] forState:UIControlStateNormal];
    [self.view addSubview:qrButton];
    
    qrButton.bottom = kScreenHeight - 64 - space;
    mapButton.bottom = qrButton.top;
}

-(void)buttonAction:(UIButton *)btn{
    if (btn.tag == 0) {
        SendWeiboViewController *send = [[SendWeiboViewController alloc]init];
        BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:send];
        
//        [self.navigationController pushViewController:send animated:YES];
        [self presentViewController:navi animated:YES completion:^{
            //弹出动画完成后  收起MMDrawer的侧边栏
            //获取MMDrawer
            MMDrawerController *mmd = self.mm_drawerController;
            //关闭右侧界面
            [mmd closeDrawerAnimated:YES completion:nil];
            
        }];
    }
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
