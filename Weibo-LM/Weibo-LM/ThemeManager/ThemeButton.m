//
//  ThemeButton.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
    }
    return self;
}

-(void)awakeFromNib{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeDidChanged) name:kThemeChangeNotificationName object:nil];
    
    [super awakeFromNib];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

-(void)themeDidChanged{
    [self setImage:[[ThemeManager shareManager]getThemeImageWithImageName:self.imageName] forState:UIControlStateNormal];
    [self setBackgroundImage:[[ThemeManager shareManager]getThemeImageWithImageName:self.backgroundImageName] forState:UIControlStateNormal];
}

-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    
    [self themeDidChanged];
}

- (void)setBackgroundImageName:(NSString *)backgroundImageName {
    _backgroundImageName = [backgroundImageName copy];
    [self themeDidChanged];
}

@end
