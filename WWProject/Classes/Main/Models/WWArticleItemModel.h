//
//  WWArticleItemModel.h
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWArticleItemModel : NSObject

// 标题
@property (nonatomic, strong) NSString *title;
// 大图
@property (nonatomic, strong) NSString *bigImageUrl;
// 作者
@property (nonatomic, strong) NSString *author;
// 微信id
@property (nonatomic, strong) NSString *wxID;
// 发布时间戳
@property (nonatomic, strong) NSString *timeStamp;
// 概述
@property (nonatomic, strong) NSString *overview;
// 正文链接
@property (nonatomic, strong) NSString *contentUrl;
// 作者主页
@property (nonatomic, strong) NSString *authorMainUrl;

@end
