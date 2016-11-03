//
//  WeiboCell.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "WeiboCell.h"
#import "WXPhotoBrowser.h"
#import "RegexKitLite.h"
#import "WeiboWebViewController.h"

@implementation WeiboCell{
    WeiboModel *model;
}

- (void)awakeFromNib {
    // 头像圆角阴影美化
    _userImageView.layer.cornerRadius = 5;
    _userImageView.layer.borderColor = [[UIColor darkGrayColor]CGColor];
    _userImageView.layer.borderWidth = .5;
    _userImageView.layer.masksToBounds = YES;
    
    _nameLabel.colorName = kHomeUserNameTextColor;
    _timeLabel.colorName = kHomeTimeLabelTextColor;
    _sourceLabel.colorName = kHomeTimeLabelTextColor;
    
    self.backgroundColor = [UIColor clearColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
    
    [self themeDidChanged];
}

-(void)themeDidChanged{
    
    ThemeManager *manager = [ThemeManager shareManager];
    
    self.weiboTextLabel.textColor = [manager getThemeColorWithColorName:kHomeWeiboTextColor];
    self.retweetedWeiboLabel.textColor = [manager getThemeColorWithColorName:kHomeReWeiboTextColor];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setLayout:(WeiboCellLayout *)layout{
    _layout = layout;
    model = _layout.model;
    
    // -----------------------用户头像-------------------------
    [_userImageView sd_setImageWithURL:model.user.avatar_large];
    // -----------------------用户昵称-------------------------
    _nameLabel.text = model.user.name;
    
    // -----------------------发文时间-------------------------
    [self getTimeText];
    
    // -----------------------来源显示-------------------------
    [self getSourceText];

    // -----------------------填充微博数据-------------------------
    self.weiboTextLabel.text = model.text;
    self.retweetedWeiboLabel.text = model.retweeted_status.text;
    self.retweetedWeiboLabel.text = [NSString stringWithFormat:@"@%@ : %@",model.retweeted_status.user.name,model.retweeted_status.text];
    if (model.retweeted_status.bmiddle_pic) {
        //转发微博有图片
        //遍历九次，获取所有的ImageView，填充数据和Frmae
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = self.imageViewArray[i];
            CGRect frame = [_layout.imageViewFrameArray[i] CGRectValue];
            imageView.frame = frame;
            
            if (i < model.retweeted_status.pic_urls.count) {
                NSDictionary *urlDic = model.retweeted_status.pic_urls[i];
                NSString *urlString = urlDic[@"thumbnail_pic"];
                NSURL *url = [NSURL URLWithString:urlString];
                [imageView sd_setImageWithURL:url];
            }
        }
    } else if (model.bmiddle_pic) {
        //当前微博有图片
        //遍历九次，获取所有的ImageView，填充数据和Frmae
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = self.imageViewArray[i];
            CGRect frame = [_layout.imageViewFrameArray[i] CGRectValue];
            
            if (i < model.pic_urls.count) {
                NSDictionary *urlDic = model.pic_urls[i];
                NSString *urlString = urlDic[@"thumbnail_pic"];
                NSURL *url = [NSURL URLWithString:urlString];
                [imageView sd_setImageWithURL:url];
            }
            imageView.frame = frame;
        }
        
    } else {
        //都没有图片
        for (UIImageView *imageView in _imageViewArray) {
            imageView.frame = CGRectZero;
        }
    }
    
    
    // -----------------------单元格布局-------------------------
    self.weiboTextLabel.frame = _layout.weiboTextLabelFrame;
    self.retweetedWeiboLabel.frame = _layout.retweetedLabelFrame;
//    self.weiboImageView.frame = _layout.weiboImageViewFrame;
    self.retweetedBackground.frame = _layout.retBackgroundFrame;
    
}

-(void)getTimeText{
    // Fri Oct 14 23:29:42 +0800 2016
    // NSString --> NSData
    // 时间格式化符
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"E M d HH:mm:ss Z yyyy"];
    NSDate *createDate = [formatter dateFromString:model.created_at];
    
    // 计算时间
    NSInteger second = -[createDate timeIntervalSinceNow];
    NSInteger mintue = second / 60;
    NSInteger hour = mintue / 60;
    NSInteger year = hour / 24 / 365;
    
    NSString *timeString = nil;
    
    // 判断时间区间
    if (second < 10) {
        timeString = @"刚刚";
    }else if (second < 60) {
        timeString = [NSString stringWithFormat:@"%li秒之前",second];
    }else if(mintue < 60){
        timeString = [NSString stringWithFormat:@"%li分钟之前",mintue];
    }else if(hour < 24){
        timeString = [NSString stringWithFormat:@"%li小时之前",hour];
    }else if(year < 1){
        // NSData --> NSString
        [formatter setDateFormat:@"M月d日 HH:mm"];
        // 设置时区为当前时区
        [formatter setLocale:[NSLocale currentLocale]];
        
        timeString = [formatter stringFromDate:createDate];
    }else{
        // NSData --> NSString
        [formatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        // 设置时区为当前时区
        [formatter setLocale:[NSLocale currentLocale]];
        
        timeString = [formatter stringFromDate:createDate];
    }
    
    
    _timeLabel.text = timeString;
}

-(void)getSourceText{
    // <a href="http://weibo.com/" rel="nofollow">14小可爱三星Galaxy Note 4</a>
    NSString *soure = model.source;
    
    if (soure.length > 0) {
        NSArray *array = [soure componentsSeparatedByString:@">"];
        
        if (array.count == 3) {
            NSString *subString = array[1];
            array = [subString componentsSeparatedByString:@"<"];
            
            _sourceLabel.text = [NSString stringWithFormat:@"来自 %@",array.firstObject];
        }else{
            _sourceLabel.text = nil;
        }
        
    }
    
}

// 属性懒加载
// 复写属性get方法
-(WXLabel *)weiboTextLabel{
    
    if (_weiboTextLabel == nil) {
        
        _weiboTextLabel = [[WXLabel alloc]initWithFrame:CGRectZero];
        _weiboTextLabel.font = kWeiboTextFont;
        _weiboTextLabel.numberOfLines = 0;
//        self.weiboTextLabel.colorName = kHomeReWeiboTextColor;
        
        _weiboTextLabel.wxLabelDelegate = self;
        _weiboTextLabel.linespace = 3;
        
        
        [self.contentView addSubview:_weiboTextLabel];
        
    }
    
    return _weiboTextLabel;
}

-(NSArray *)imageViewArray{

    
    if (_imageViewArray == nil) {
        NSMutableArray *mArray = [NSMutableArray array];
        
        for (int i = 0; i < 9; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
            [self.contentView addSubview:imageView];
            
            [mArray addObject:imageView];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds  = YES;
            
            //添加点击事件
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapAction:)];
            [imageView addGestureRecognizer:tap];
            [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        }
        
        _imageViewArray = [mArray copy];
    }
    return _imageViewArray;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(UILabel *)retweetedWeiboLabel{
    if (_retweetedWeiboLabel == nil) {
        
        _retweetedWeiboLabel = [[ThemeLabel alloc]initWithFrame:CGRectZero];
        _retweetedWeiboLabel.font = kRetweetedFont;
        _retweetedWeiboLabel.numberOfLines = 0;
        _retweetedWeiboLabel.colorName = kHomeReWeiboTextColor;
        
        [self.contentView addSubview:_retweetedWeiboLabel];
        
    }
    
    return _retweetedWeiboLabel;
}

-(ThemeImageView *)retweetedBackground{
    if (_retweetedBackground
        == nil) {
        _retweetedBackground = [[ThemeImageView alloc]initWithFrame:CGRectZero];
        
        _retweetedBackground.leftCapWidth = 27;
        _retweetedBackground.topCapHeight = 20;
        
        _retweetedBackground.imageName = @"timeline_rt_border_9.png";
        
        [self.contentView insertSubview:_retweetedBackground atIndex:0];
    }
    
    return _retweetedBackground;
}



#pragma mark - 大图浏览
- (void)imageViewTapAction:(UITapGestureRecognizer *)tap {
    
    //获取被点击的图片视图
    UIImageView *imageView = (UIImageView *)tap.view;
    
    NSInteger imageIndex = [_imageViewArray indexOfObject:imageView];
    
    //判断是否找到
    if (imageIndex == NSNotFound) {
        return;
    }
    
//    []
    
    //显示图片浏览器
    [WXPhotoBrowser showImageInView:self.window    //显示的父视图
                   selectImageIndex:imageIndex   //当前需要显示的图片，在整个数组中的index
                           delegate:self];
    
}


//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser {
    if (_layout.model.retweeted_status.pic_urls.count == 0) {
        //1. 当前微博中的图片
        return  _layout.model.pic_urls.count;
        
    } else {
        //2. 转发微博中的图片
        return _layout.model.retweeted_status.pic_urls.count;
    }
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    //创建Photo对象
    WXPhoto *photo = [[WXPhoto alloc] init];
    
    //设置大图URL地址
    //两种情况
    NSString *imageURLString;
    if (_layout.model.retweeted_status.pic_urls.count == 0) {
        //1. 当前微博中的图片
        NSDictionary *dic = _layout.model.pic_urls[index];
        imageURLString = dic[@"thumbnail_pic"];
    } else {
        //2. 转发微博中的图片
        NSDictionary *dic = _layout.model.retweeted_status.pic_urls[index];
        imageURLString = dic[@"thumbnail_pic"];
    }
    //设置原始视图
    photo.srcImageView = _imageViewArray[index];

    //http://ww2.sinaimg.cn/thumbnail/655dd5f3gw1f8qhur5jocj20by07zt9m.jpg
    //http://ww2.sinaimg.cn/large/655dd5f3gw1f8qhur5jocj20by07zt9m.jpg
    //将缩略图地址 手动转化为大图地址

    imageURLString = [imageURLString stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    photo.url = [NSURL URLWithString:imageURLString];
    
    return photo;
}

#pragma mark - WXLabelDelegate
//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    return @"(#[^#]+#)|(@[\\w-]{2,30})|(http(s)?://([a-zA-Z0-9._-]+(/)?)+)";
}
//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    return [[ThemeManager shareManager]getThemeColorWithColorName:kHomeLinkColor];
}
//设置当前文本手指经过的颜色
- (UIColor *)passColorWithWXLabel:(WXLabel *)wxLabel{
    return [UIColor redColor];
}

//手指离开当前超链接文本响应的协议方法
- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context{
    NSString *regex = @"http(s)?://([a-zA-Z0-9-._]+(/)?)+";
    
    if ([context isMatchedByRegex:regex]) {
        // 打开网页浏览
        NSURL *url = [NSURL URLWithString:context];
        
        WeiboWebViewController *webView = [[WeiboWebViewController alloc]initWithURL:url];
        
        [[self navigationController] pushViewController:webView animated:YES];
        
    }
}

//-(NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel{

//}

#pragma mark - UIView + UINavigationController 
-(UINavigationController *)navigationController{
    UIResponder *next = self.nextResponder;
    
    while (next) {
        if ([next isKindOfClass:[UINavigationController class]]) {
            return(UINavigationController *)next;
        }else{
            next = next.nextResponder;
        }
    }
    
    return nil;
}

@end
