//
//  WeiboCellLayout.m
//  Weibo-LM
//
//  Created by mymac on 16/10/15.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "WeiboCellLayout.h"

@implementation WeiboCellLayout

-(void)setModel:(WeiboModel *)model{
    //判断是否发生改变
    if (_model == model) {
        return;
    }
    _model = model;
    
    
    //归零总高度
    _cellHeight = 0;
    //顶部视图高度
    _cellHeight += kWeiboTopViewHeight;
    
    
    //计算各个视图的frame
    //------------------------正文------------------------
    //根据文本来修改Label的大小
    NSString *text = _model.text;
    //文本的最大范围
    //    CGSize maxSize = CGSizeMake(kScreenWidth - kSpaceWidth * 2, 2000);
    //    NSDictionary *attributes = @{NSFontAttributeName : kWeiboTextFont};
    //    //获取Label所显示的范围
    //    CGRect rect = [text boundingRectWithSize:maxSize
    //                                     options:NSStringDrawingUsesLineFragmentOrigin
    //                                  attributes:attributes
    //                                     context:nil];
    //    //获取高度
    //    CGFloat textLabelHeight = rect.size.height;
    
    //直接使用WXLabel中的方法 来计算文本高度
    CGFloat textLabelHeight = [WXLabel getTextHeight:kWeiboTextFont.pointSize width:kScreenWidth - kSpaceWidth * 2 text:text linespace:2];
    
    
    
    //Label的frame
    _weiboTextLabelFrame = CGRectMake(kSpaceWidth, kWeiboTopViewHeight, kScreenWidth - 2 * kSpaceWidth, textLabelHeight+10);
    
    //累加正文高度
    _cellHeight += textLabelHeight;
    //累加空隙
    _cellHeight += kSpaceWidth;
    
    
    //判断是否有转发微博
    //1. 有转发微博
    //2. 没有转发微博（判断是否有图片）
    if (_model.retweeted_status) {
        //计算转发微博的正文frame
        
        //根据文本来修改Label的大小
        NSString *text = _model.retweeted_status.text;
        //文本的最大范围
        //        CGSize maxSize = CGSizeMake(kScreenWidth - kSpaceWidth * 4, 2000);
        //        NSDictionary *attributes = @{NSFontAttributeName : kRetweetedFont};
        //        //获取Label所显示的范围
        //        CGRect rect = [text boundingRectWithSize:maxSize
        //                                         options:NSStringDrawingUsesLineFragmentOrigin
        //                                      attributes:attributes
        //                                         context:nil];
        //        //获取高度
        //        CGFloat retweetedHeight = rect.size.height;
        
        
        CGFloat retweetedHeight = [WXLabel getTextHeight:kRetweetedFont.pointSize width:kScreenWidth - kSpaceWidth * 4 text:text linespace:2];
        
        _retweetedLabelFrame = CGRectMake(2 * kSpaceWidth, CGRectGetMaxY(_weiboTextLabelFrame) + kSpaceWidth, kScreenWidth - kSpaceWidth * 4, retweetedHeight);
        //转发微博背景
        _retBackgroundFrame = CGRectMake(kSpaceWidth, _retweetedLabelFrame.origin.y - kSpaceWidth, kScreenWidth - 2 * kSpaceWidth, retweetedHeight + 2 * kSpaceWidth);
        
        //判断转发的微博 是否有图片
        CGFloat imageHeight = [self layoutImageViewWithImageCount:_model.retweeted_status.pic_urls.count imageViewTop:CGRectGetMaxY(_retweetedLabelFrame) + kSpaceWidth viewWidth:kScreenWidth - 4 * kSpaceWidth];
        
        
        
        //累加总高度
        _cellHeight += retweetedHeight + 2 * kSpaceWidth + imageHeight;
        //背景高度 累加图片高度
        _retBackgroundFrame.size.height += imageHeight;
        
    } else {
        //没有转发微博
        _retweetedLabelFrame = CGRectZero;
        _retBackgroundFrame = CGRectZero;
        
        //------------------------图片------------------------
        
        //累加图片高度
        _cellHeight += [self layoutImageViewWithImageCount:model.pic_urls.count imageViewTop:CGRectGetMaxY(_weiboTextLabelFrame) viewWidth:kScreenWidth - 2 * kSpaceWidth];
        
        
        
    }
}

// 自动布局九个图片视图
// 返回值 所有图片在单元格中 所占用的高度
- (CGFloat)layoutImageViewWithImageCount:(NSInteger)count      //图片数量
                                imageViewTop:(CGFloat)top          //图片视图最顶部的Y值
                                   viewWidth:(CGFloat)viewWidth    //整个图片视图的宽度
{
    
    //图片之间空隙
    CGFloat imageSpace = 5.0;
    
    //判断传入的图片数量是否合理
    if (count > 9 || count <= 0) {
        //图片数量不合理，不布局图片
        _imageViewFrameArray = nil;
        
        return 0;
    }
    //1     一行一列
    //2     一行两列
    //3     一行三列
    //4     两行两列
    //5.6   两行三列
    //7.8.9 三行三列
    //行列形式布局，采用两层循环嵌套模式，外层为行。内层为列
    //行数不同，区别只是在外层循环中多执行了一次循环
    //列数不同，会影响每一个图片的大小
    CGFloat imageWidth = 0;
    //计算列数 列数会影响内存循环的循环次数
    NSInteger numberOfColumn = 0;
    //行数 决定了外层循环的次数
    NSInteger numberOfLine = (count - 1) / 3 + 1;
    
    
    //首先以列数为区分，来计算布局条件
    if (count == 1) {
        //一列
        //每个图片宽度 为总宽度的70%
        imageWidth = viewWidth * 0.7;
        numberOfColumn = 1;
    } else if (count ==2 || count == 4) {
        //两列
        imageWidth = (viewWidth - imageSpace) / 2;
        numberOfColumn = 2;
    } else {
        //三列
        imageWidth = (viewWidth - 2 * imageSpace) / 3;
        numberOfColumn = 3;
    }
    
    //内外两层的嵌套循环  布局行列形式的视图
    NSMutableArray *mArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < numberOfLine; i++) {
        for (int j = 0; j < numberOfColumn; j++) {
            
            NSInteger index = i * numberOfColumn + j;
            
            //判断当前的图片序号有没有超出图片总数
            if (index >= count) {
                //跳出循环
                break;
            }
            
            //i表示行号
            //j表示列号
            CGFloat leftSpace = (kScreenWidth - viewWidth) / 2;
            CGRect frame = CGRectMake(leftSpace + (imageWidth + imageSpace) * j, top + (imageWidth + imageSpace) * i, imageWidth, imageWidth);
            
            //将CGRect 包装成 NSValue
            [mArray addObject:[NSValue valueWithCGRect:frame]];
            
        }
    }
    
    //补全数组到九个
    while (mArray.count < 9) {
        [mArray addObject:[NSValue valueWithCGRect:CGRectZero]];
    }
    
    _imageViewFrameArray = [mArray copy];
    
    //返回图片总高度
    return numberOfLine * (imageWidth + imageSpace) + kSpaceWidth;
    
}

@end
