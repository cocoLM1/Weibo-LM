//
//  MainTabBarController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/12.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "MainTabBarController.h"
#import "ThemeImageView.h"
#import "ThemeButton.h"
@interface MainTabBarController (){
    ThemeImageView *_selectedImageView;
}

@end

@implementation MainTabBarController

-(instancetype)init{
    if (self = [super init]) {
        // 数组保存文件名
        NSArray *fileName = @[@"Home",
                              @"Message",
                              @"Profile",
                              @"Discover",
                              @"More"];
        
        NSMutableArray *controllers = [NSMutableArray array];
        
        // 读取StoryBoard  添加子视图控制器
        for (NSString *boardName in fileName) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:boardName bundle:[NSBundle mainBundle]];
            
            UIViewController *viewController = [storyBoard instantiateInitialViewController];
            
            [controllers addObject:viewController];
        }
        
        self.viewControllers = [controllers copy];

        [self customTabBar];
    }
    return self;
}

-(void)customTabBar{
    // 移除系统自带标签按钮 UITabBarButton
    for (UIView *view in self.tabBar.subviews) {
        Class tabbarButton = NSClassFromString(@"UITabBarButton");
        if ([view isKindOfClass:tabbarButton]) {
            [view removeFromSuperview];
        }
    }
    
    // 自定义标签按钮
    CGFloat buttonWidth = kScreenWidth/5;
    CGFloat buttonHeight = self.tabBar.bounds.size.height;
    
    for (int i = 0; i < self.viewControllers.count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"home_tab_icon_%i.png",i+1];
        
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        button.tag = 100 + i;
        
        [self.tabBar addSubview:button];
        
        button.imageName = imageName;
        
        [button addTarget:self action:@selector(tabBarButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // 标签栏背景
    ThemeImageView *bgImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, -5, kScreenWidth, 56)];
    bgImageView.imageName = @"mask_navbar.png";
    [self.tabBar insertSubview:bgImageView atIndex:0];
    
    // 标签栏阴影线
    self.tabBar.shadowImage = [[UIImage alloc]init];
    
    // 创建选中试图
    _selectedImageView = [[ThemeImageView alloc]initWithFrame:CGRectMake(0, 0, buttonWidth, buttonHeight)];
    _selectedImageView.imageName = @"home_bottom_tab_arrow.png";
    
    [self.tabBar insertSubview:_selectedImageView atIndex:1];
}

-(void)tabBarButtonAction:(UIButton *)btn{
    NSInteger i = btn.tag - 100;
    if (i >= 0 && i < self.viewControllers.count) {
        self.selectedIndex = btn.tag - 100;
        
        [UIView animateWithDuration:.2 animations:^{
            _selectedImageView.center = btn.center;
        }];
    }
    
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
