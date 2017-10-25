//
//  WWTools.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WWArticleItemModel;
@class WWAccountModel;

@interface WWTools : NSObject

+ (NSDictionary *)combinedParamsForRequestWithSearchUrl:(NSString *)searchUrl replaceString:(NSString *)replaceString;

+ (void)archiveFavoriteArticle:(WWArticleItemModel *)model;

+ (void)archiveFavoriteAccount:(WWAccountModel *)model;

+ (void)removeFavoriteArticle:(WWArticleItemModel *)model;

+ (void)removeFavoriteAccount:(WWAccountModel *)model;

+ (BOOL)hasCacheFavoriteArticle:(WWArticleItemModel *)model;

+ (BOOL)hasCacheFavoriteAccount:(WWAccountModel *)model;

+ (NSArray <WWArticleItemModel *> *)cacheFavoriteArticles;

+ (NSArray <WWAccountModel *> *)cacheFavoriteAccounts;

@end
