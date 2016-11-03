//
//  ThemeImageView.m
//  Weibo-LM
//
//  Created by mymac on 16/10/12.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
        self.image = [UIImage imageNamed:@"Skins/bluemoon/avatar_default.png"];
    }
    
    return self;
}

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
    self.image = [UIImage imageNamed:@"Skins/bluemoon/avatar_default.png"];
    
    [super awakeFromNib];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)themeDidChanged{
    
    UIImage *image = [[ThemeManager shareManager]getThemeImageWithImageName:self.imageName];
    
    
    self.image = [image stretchableImageWithLeftCapWidth:_leftCapWidth topCapHeight:_topCapHeight];

    
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    [self themeDidChanged];
}

@end
