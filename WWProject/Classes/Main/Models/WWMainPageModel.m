//
//  WWMainPageModel.m
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWMainPageModel.h"

@implementation WWMainPageModel

+ (instancetype)sharedInstance
{
    static WWMainPageModel* model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[WWMainPageModel alloc] init];
    });
    return model;
}

@end
