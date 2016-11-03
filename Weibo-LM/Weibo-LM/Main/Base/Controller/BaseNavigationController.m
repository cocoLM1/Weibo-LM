//
//  BaseNavigationController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/12.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     1. 监听通知
     2. 在接受到通知后 更改图片
     */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChenged) name:kThemeChangeNotificationName object:nil];
    
    
    //设置导航栏标题样式
    //构造样式字典
    NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:20],
                          NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.navigationBar.titleTextAttributes = dic;
    //设置导航栏不透明
    self.navigationBar.translucent = NO;
    
    
    //手动调用themeDidChenged 来加载厨初始图片
    [self themeDidChenged];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)themeDidChenged {
    //设置背景图片
    //mask_titlebar.png mask_titlebar64.png
    //因为iOS7之前的设备 导航栏高度为44，iOS7之后的设备导航栏高度为44+20
    CGFloat systemVersion = kSystemVersion;
    
    if (systemVersion >= 7.0) {
        //系统版本>=7.0 mask_titlebar64.png
        //        UIImage *image = [UIImage imageNamed:@"Skins/bluemoon/mask_titlebar64.png"];
        //通过ThemeManager来获取当前主题下的导航栏图片
        UIImage *image = [[ThemeManager shareManager] getThemeImageWithImageName:@"mask_titlebar64@2x.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        //系统版本<7.0 mask_titlebar.png
        //        UIImage *image = [UIImage imageNamed:@"Skins/bluemoon/mask_titlebar.png"];
        UIImage *image = [[ThemeManager shareManager] getThemeImageWithImageName:@"mask_titlebar@2x.png"];
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
}

//状态栏文本颜色
- (UIStatusBarStyle)preferredStatusBarStyle {
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
