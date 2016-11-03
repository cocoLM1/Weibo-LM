//
//  WeiboModel.h
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface WeiboModel : NSObject

@property (copy, nonatomic)     NSString    *source;            //微博来源
@property (copy, nonatomic)     NSString    *created_at;        //发布时间
@property (copy, nonatomic)     NSString    *idstr;             //微博编号
@property (copy, nonatomic)     NSString    *text;              //微博文本
@property (assign, nonatomic)   NSInteger   reposts_count;      //转发数
@property (assign, nonatomic)   NSInteger   comments_count;     //评论数
@property (assign, nonatomic)   NSInteger   attitudes_count;    //点赞数
@property (copy, nonatomic)     NSURL       *thumbnail_pic;     //缩略图片地址
@property (copy, nonatomic)     NSURL       *bmiddle_pic;       //中等尺寸图片地址
@property (copy, nonatomic)     NSURL       *original_pic;      //原始图片地址
@property (copy, nonatomic)     NSDictionary *geo;              //位置信息

//在一个类的属性中，嵌套有其他类的对象。YYModel能够自动的来读取里面的属性
@property (strong, nonatomic)   UserModel   *user;              //发微博的用户信息
@property (strong, nonatomic)   WeiboModel  *retweeted_status;  //转发微博

@property (copy, nonatomic)     NSArray     *pic_urls;          //多图地址

@end
