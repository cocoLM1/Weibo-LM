//
//  ThemeManager.h
//  Weibo-LM
//
//  Created by mymac on 16/10/12.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ThemeManager : NSObject

@property(nonatomic,copy)NSString *currentThemeName;

+(ThemeManager *)shareManager;

-(UIImage *)getThemeImageWithImageName:(NSString *)imageName;
-(UIColor *)getThemeColorWithColorName:(NSString *)colorName;

@end
