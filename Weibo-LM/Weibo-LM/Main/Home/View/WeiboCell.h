//
//  WeiboCell.h
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCellLayout.h"
#import "WXPhotoBrowser.h"
#import "WXLabel.h"
@interface WeiboCell : UITableViewCell<PhotoBrowerDelegate,WXLabelDelegate>

// 微博单元格顶部用户信息
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *nameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *timeLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *sourceLabel;


// 微博正文
@property (strong, nonatomic) WXLabel *weiboTextLabel;
//@property (strong, nonatomic) UIImageView *weiboImageView;
@property (strong, nonatomic) NSArray *imageViewArray;

// 转发微博
@property (strong, nonatomic) ThemeLabel *retweetedWeiboLabel;
@property (strong, nonatomic) ThemeImageView *retweetedBackground;


@property (strong, nonatomic) WeiboCellLayout *layout;


@end
