//
//  WWWXArticleAPIManager.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWWXArticleAPIManager;
@class WWArticleItemModel;

typedef void(^WXArticleInfoCompleteBlock)(WWWXArticleAPIManager *);

@interface WWWXArticleAPIManager : KOGAPIBaseManager

@property (nonatomic, strong) NSString *authorMainUrl;
@property (nonatomic, strong) NSString *contentUrl;
@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) WWArticleItemModel *articleInfo;

- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(WXArticleInfoCompleteBlock)block;

@end
