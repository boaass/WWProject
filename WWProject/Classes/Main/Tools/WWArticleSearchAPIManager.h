//
//  WWArticleSearchAPIManager.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/13.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWArticleSearchAPIManager;
@class WWArticleItemModel;

typedef void(^ArticleInfoCompleteBlock)(WWArticleSearchAPIManager *);

@interface WWArticleSearchAPIManager : KOGAPIBaseManager

@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSArray <WWArticleItemModel *> *articleInfos;

- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(ArticleInfoCompleteBlock)block;

- (void)nextPage:(ArticleInfoCompleteBlock)block;

@end
