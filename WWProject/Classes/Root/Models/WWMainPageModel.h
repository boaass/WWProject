//
//  WWMainPageModel.h
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WWArticleItemModel.h"

@interface WWMainPageModel : NSObject

// 轮播图及对应url
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *carouselImages;
// 标签及对应url
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *tags;
// 热词及对应热度
@property (nonatomic, strong) NSDictionary <NSString *, NSString *> *hotWords;
// 公众号搜索地址
@property (nonatomic, strong) NSString *accountSearchUrl;
// 文章搜索地址
@property (nonatomic, strong) NSString *articleSearchUrl;

@end
