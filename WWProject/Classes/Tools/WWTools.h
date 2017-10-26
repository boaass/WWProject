//
//  WWTools.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WWArticleCacheModel;
@class WWAccountCacheModel;
@class WWArticleItemModel;
@class WWAccountModel;

@interface WWTools : NSObject

+ (NSDictionary *)combinedParamsForRequestWithSearchUrl:(NSString *)searchUrl replaceString:(NSString *)replaceString;

+ (void)archiveFavoriteArticle:(WWArticleCacheModel *)model;

+ (void)archiveFavoriteAccount:(WWAccountCacheModel *)model;

+ (void)removeFavoriteArticle:(WWArticleItemModel *)model;

+ (void)removeFavoriteAccount:(WWAccountModel *)model;

+ (BOOL)hasCacheFavoriteArticle:(WWArticleItemModel *)model;

+ (BOOL)hasCacheFavoriteAccount:(WWAccountModel *)model;

+ (void)refreshCacheFavoriteArticleWithBlcok:(void (^)())block;

+ (void)refreshCacheFavoriteAccountWithBlock:(void (^)())block;

+ (NSArray <WWArticleCacheModel *> *)cacheFavoriteArticles;

+ (NSArray <WWAccountCacheModel *> *)cacheFavoriteAccounts;

@end
