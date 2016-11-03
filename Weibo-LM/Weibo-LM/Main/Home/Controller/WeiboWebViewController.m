//
//  WeiboWebViewController.m
//  Weibo-LM
//
//  Created by mymac on 16/10/21.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "WeiboWebViewController.h"

@interface WeiboWebViewController ()
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation WeiboWebViewController

-(UIWebView *)webView{
    if (_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }
    
    return _webView;
}

-(instancetype)initWithURL:(NSURL *)url{
    if (self = [super init]) {
        _url = url;
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

-(void)setUrl:(NSURL *)url{
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.url) {
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.url];
        
        [self.webView loadRequest:request];
    }
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
