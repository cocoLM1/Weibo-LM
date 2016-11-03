//
//  WeiboCellLayout.h
//  Weibo-LM
//
//  Created by mymac on 16/10/15.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#define kWeiboTextFont      [UIFont systemFontOfSize:18]
#define kSpaceWidth         10
#define kImageSpaceWidth    5
#define kWeiboImageWidth    200
#define kWeiboTopViewHeight 60
#define kRetweetedFont      [UIFont systemFontOfSize:16]

#import <Foundation/Foundation.h>
#import "WeiboModel.h"
#import "WXLabel.h"

@interface WeiboCellLayout : NSObject
// model
@property (nonatomic, strong) WeiboModel *model;
//frame
@property (nonatomic, assign, readonly) CGRect weiboTextLabelFrame;
//@property (nonatomic, assign, readonly) CGRect weiboImageViewFrame;
@property (nonatomic, assign, readonly) CGRect retweetedLabelFrame;
@property (nonatomic, assign, readonly) CGRect retBackgroundFrame;

@property (nonatomic, strong) NSArray *imageViewFrameArray;
//height
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
