//
//  WWAcountModel.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWAcountModel : NSObject
// 公众号名称
@property (nonatomic, strong) NSString *author;
// 公众号主页
@property (nonatomic, strong) NSString *authorMainUrl;
// 微信号
@property (nonatomic, strong) NSString *wxID;
// 最近月发文数量
@property (nonatomic, strong) NSString *lastMonthArticleNum;
// 头像
@property (nonatomic, strong) NSString *iconUrl;
// 功能介绍
@property (nonatomic, strong) NSString *featureDescription;
// 微信认证
@property (nonatomic, strong) NSString *wxCertification;
// 最近文章
@property (nonatomic, strong) NSString *lastArticle;
// 最近发文时间
@property (nonatomic, strong) NSString *time;
// 文章链接
@property (nonatomic, strong) NSString *contentUrl;

@end
