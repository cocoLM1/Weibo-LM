//
//  MainTabBarController.m
//  Weibo-LM
//
//  Created by mymac on 16/9/29.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

#pragma mark - 初始化
//覆写 init
-(instancetype)init{
    if (self = [super init]) {
        [self createSubViewController];
        
        [self createTarBar];
    }
    
    return self;
}

//子视图控制器的创建
-(void)createSubViewController{
    NSArray *storyboardNames = @[@"Home",@"Message",@"Discover",@"Profile",@"More"];
    
    NSMutableArray *naviArr = [[NSMutableArray alloc]init];
    
    // 遍历
    for (NSString *sbName in storyboardNames) {
        // 读取故事版
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle mainBundle]];
        
        UINavigationController *navi = [storyBoard instantiateInitialViewController];
        
        [naviArr addObject:navi];
    }
    
    self.viewControllers = [naviArr copy];
}

//自定义标签栏
-(void)createTarBar{
    self.tabBar.backgroundImage = [UIImage imageNamed:@"mask_navbar"];
    
    for (UIView *subView in self.tabBar.subviews) {
        Class cls = NSClassFromString(@"UITabBarButton");
        
        if ([subView isKindOfClass:cls]) {
            [subView removeFromSuperview];
        }
    }
    
    float width = kScreenWidth/5;
    float height = self.tabBar.bounds.size.height;
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        
        CGRect frame = CGRectMake(i * width, 5, width, height);
        button.frame = frame;
        
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_tab_icon_%d",i+1]] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tabBar addSubview:button];
    }
    
    self.tabBar.shadowImage = [[UIImage alloc]init];
}

-(void)btnAction:(UIButton *)btn{
    self.selectedIndex = btn.tag - 100;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
