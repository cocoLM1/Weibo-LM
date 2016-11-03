//
//  WeiboModel.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "WeiboModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel

-(NSString *)description{
    return [NSString stringWithFormat:@"%@:%@",_user.name,_text];
}

-(BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSString *weiboText = self.text;
    
    NSString *regex = @"\\[\\w+\\]";
    
    NSArray *array = [weiboText componentsMatchedByRegex:regex];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray *emoticons = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString *str in array) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chs = %@",str];
        
        NSArray *result = [emoticons filteredArrayUsingPredicate:predicate];
        
        if (result.count == 1) {
            NSDictionary *emoticonDic = [result firstObject];
            
            NSString *imageName = emoticonDic[@"png"];
            NSString *imageURL = [NSString stringWithFormat:@"<image url = '%@'>",imageName];
            
            weiboText = [weiboText stringByReplacingOccurrencesOfString:str withString:imageURL];
        }
    }
    
    self.text = [weiboText copy];

    return YES;
}



@end
