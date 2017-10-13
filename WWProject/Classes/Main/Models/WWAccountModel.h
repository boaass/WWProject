//
//  WWAccountModel.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWAccountModel : NSObject
// 公众号名称
@property (nonatomic, strong) NSString *author;
// 公众号主页
@property (nonatomic, strong) NSString *authorMainUrl;
// 微信号
@property (nonatomic, strong) NSString *wxID;
// 头像
@property (nonatomic, strong) NSString *iconUrl;
/* 
 功能介绍
 微信认证
 最近文章 
**/
@property (nonatomic, strong) NSArray *descriptions;
// 文章链接
@property (nonatomic, strong) NSString *contentUrl;

@end
