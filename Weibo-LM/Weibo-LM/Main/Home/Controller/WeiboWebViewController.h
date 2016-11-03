//
//  WeiboWebViewController.h
//  Weibo-LM
//
//  Created by mymac on 16/10/21.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiboWebViewController : BaseViewController

@property(nonatomic,strong)NSURL *url;

-(instancetype)initWithURL:(NSURL *)url;

@end
