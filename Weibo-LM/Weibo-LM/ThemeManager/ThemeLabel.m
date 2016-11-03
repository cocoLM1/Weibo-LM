//
//  ThemeLabel.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"
@implementation ThemeLabel

#pragma mark - 开启通知监听
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //开启通知的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
    }
    
    return self;
}

//从StroyBoard加载视图 不会自动调用initWithFrame
//当对象从SB中加载时 会调用 awakeFromNib
- (void)awakeFromNib {
    //开启通知的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
    
    [super awakeFromNib];
    
}
#pragma mark - 移除通知
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//主题改变
- (void)themeDidChanged {
    //从Manager中获取对应的颜色，并显示
    ThemeManager *manager = [ThemeManager shareManager];
    //设置主题字体颜色
    self.textColor = [manager getThemeColorWithColorName:_colorName];
}

//手动刷初始颜色
- (void)setColorName:(NSString *)colorName {
    _colorName = [colorName copy];
    
    [self themeDidChanged];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
