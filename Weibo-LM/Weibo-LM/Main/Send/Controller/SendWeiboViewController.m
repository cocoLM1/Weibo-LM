//
//  SendWeiboViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/24.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "SendWeiboViewController.h"
#import "LocationViewController.h"

#define kToolViewHeight 40
@interface SendWeiboViewController (){
    UITextView *_weiboTextView;
    UIView *_toolView;
    
    
}

@end

@implementation SendWeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"发微博";
    [self createNavigationBarItem];
    [self createTextView];
}

#pragma mark - 创建界面
-(void)createNavigationBarItem{
    ThemeButton *cancelBtn = [ThemeButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    cancelBtn.backgroundImageName = @"titlebar_button_9.png";
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    ThemeButton *sendBtn = [ThemeButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, 60, 44);
    sendBtn.backgroundImageName = @"titlebar_button_9.png";
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = sendItem;
    
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)createTextView{
    //TextView
    _weiboTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kToolViewHeight)];
    _weiboTextView.backgroundColor = [UIColor clearColor];
    _weiboTextView.textColor = [[ThemeManager shareManager] getThemeColorWithColorName:kHomeWeiboTextColor];
    
    [self.view addSubview:_weiboTextView];
    
    //ToolView
    _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kToolViewHeight)];
    _toolView.top = _weiboTextView.bottom;
//    _toolView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_toolView];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    NSArray *imageName = @[@"compose_toolbar_1.png",@"compose_toolbar_3.png",@"compose_toolbar_4.png",@"compose_toolbar_5.png",@"compose_toolbar_6.png"];
    
    CGFloat buttonWudth = kScreenWidth / imageName.count;
    
    for (int i = 0; i < imageName.count; i++) {
//        UIImage *image = [UIImage imageNamed:imageName[i]];
        ThemeButton *btn = [ThemeButton buttonWithType:UIButtonTypeCustom];
        btn.imageName = imageName[i];
        btn.tag = i;
        btn.frame = CGRectMake(buttonWudth * i, 0, buttonWudth, kToolViewHeight);
        
        [btn addTarget:self action:@selector(toolViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:btn];
    }
    
}

#pragma mark - buttonAction
-(void)cancelAction{
    [_weiboTextView resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)keyboardWillChangeFrame:(NSNotification *)noti{
    NSLog(@"%@",noti.userInfo);
    NSValue *frameValue = noti.userInfo[@"UIKeyboardFrameEndUserInfoKey"];
    CGRect keyboardFrame = [frameValue CGRectValue];
    
    _toolView.bottom = keyboardFrame.origin.y - 64;
    _weiboTextView.height = _toolView.top;
}

-(void)sendAction{

}

#pragma mark - toolViewButtonAction
-(void)toolViewButtonAction:(UIButton *)btn{
    if (btn.tag == 3) {
        [_weiboTextView resignFirstResponder];
        
        LocationViewController *location = [[LocationViewController alloc]init];
        [self.navigationController pushViewController:location animated:YES];
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
