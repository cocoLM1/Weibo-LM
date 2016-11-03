//
//  UserModel.m
//  Weibo-LM
//
//  Created by mymac on 16/10/14.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)modelCustomPropertyMapper {
    //属性名 ---- key
    //@{@"属性名" : @"key"};
    return @{@"des" : @"description"};
}

@end
