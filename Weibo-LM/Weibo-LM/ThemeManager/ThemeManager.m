//
//  ThemeManager.m
//  Weibo-LM
//
//  Created by mymac on 16/10/12.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "ThemeManager.h"
#define kCurrentThemeNameKey  @"kCurrentThemeNameKey"

@implementation ThemeManager{
    NSDictionary *_themeDic;
    NSDictionary *_colorConfig;
}

#pragma mark - 构建单例类
+(ThemeManager *)shareManager{
    static ThemeManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[super allocWithZone:nil]init];
        }
    });
    
    return manager;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareManager];
}

-(id)copy{
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"theme" ofType:@"plist"];
        _themeDic = [[NSDictionary alloc]initWithContentsOfFile:filePath];
        
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        NSString *theme = [userDef objectForKey:kCurrentThemeNameKey];
        if (theme == nil) {
            _currentThemeName = @"Blue Moon";
        }else{
            _currentThemeName = theme;
        }
        
        [self loadColorConfig];
        
    }
    return self;
}

-(void)setCurrentThemeName:(NSString *)currentThemeName{
    if ([_currentThemeName isEqualToString:currentThemeName]) {
        return;
    }
    
    NSString *path = _themeDic[currentThemeName];
    if (path == nil) {
        return;
    }
    _currentThemeName = [currentThemeName copy];
    [self loadColorConfig];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kThemeChangeNotificationName object:nil];
        
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setObject:_currentThemeName forKey:kCurrentThemeNameKey];
}

-(UIImage *)getThemeImageWithImageName:(NSString *)imageName{
    NSString *path = _themeDic[self.currentThemeName];
    NSString *imagePath = [NSString stringWithFormat:@"%@/%@",path,imageName];
    
    UIImage *img = [UIImage imageNamed:imagePath];
    
    return img;
}


- (UIColor *)getThemeColorWithColorName:(NSString *)colorName {
    
    /*
     每一种主题，都有一套颜色配置文件，在主题路径下的config.plist文件
     在不同的主题下，需要读取不同的配置文件，然后从中再来获取颜色
     */
    //错误的思路，每次读取文件，都会消耗很大的系统资源
    //1. 根据当前主题，来读取配置文件
    //2. 到配置文件中，找到颜色数据 RGB值
    //3. 生成UIColor对象
    
    
    //正确思路
    //将颜色配置文件，读取到内存中保存(内存的读取速度，比磁盘快很多倍)
    //在需要获取颜色时，直接从内存中读取颜色数据，并且处理成UIColor
    //当切换主题时，需要重新读取新主题的配置文件(第一次创建时，需要读取初始数据)
    
    //1.通过colorName 从config中获取相对应的颜色RGB数值
    NSDictionary *colorDic = _colorConfig[colorName];
    
    NSNumber *R = colorDic[@"R"];
    NSNumber *G = colorDic[@"G"];
    NSNumber *B = colorDic[@"B"];
    NSNumber *A = colorDic[@"alpha"];
    
    //转化为float类型
    CGFloat red = [R floatValue];
    CGFloat green = [G floatValue];
    CGFloat blue = [B floatValue];
    CGFloat alpha = [A floatValue];
    //没有透明度的情况
    if (alpha == 0) {
        alpha = 1;
    }
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    
}


#pragma mark - 读取颜色数据
//读取当前主题下的颜色数据
- (void)loadColorConfig {
    //1. 获取文件路径    系统资源包的根目录路径/Skins/bluemoon/config.plist
    //获取mainBunble的根目录路径
    NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
    //主题文件夹路径
    NSString *filePath = _themeDic[_currentThemeName];
    //拼接路径
    NSString *path = [NSString stringWithFormat:@"%@/%@/config.plist", bundlePath, filePath];
//    NSLog(@"%@", path);
    //2. 读取文件到内存中
    _colorConfig = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    
    
}
@end
