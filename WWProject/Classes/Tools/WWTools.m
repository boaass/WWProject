//
//  WWTools.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "WWArticleItemModel.h"
#import "WWAccountModel.h"

#define WWFavoriteArticleCachePath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"WWFavoriteArticleCachePath"]
#define WWFavoriteAccountCachePath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"WWFavoriteAccountCachePath"]

@implementation WWTools

+ (NSDictionary *)combinedParamsForRequestWithSearchUrl:(NSString *)searchUrl replaceString:(NSString *)replaceString
{
    NSString *fullUrl = [searchUrl stringByReplacingOccurrencesOfString:replaceString withString:@""];
    NSRange segRange = [fullUrl rangeOfString:@"?"];
    NSString *searchMethod = [fullUrl substringToIndex:segRange.location];
    NSString *paramsStr = [fullUrl substringFromIndex:segRange.location+1];
    NSDictionary *params = [paramsStr paramStringToDictionary];
    NSDictionary *searchParams = params;
    return [NSDictionary dictionaryWithObject:searchParams forKey:searchMethod];
}

#pragma mark - cache file
+ (void)archiveFavoriteArticle:(WWArticleItemModel *)model
{
    [[NSFileManager defaultManager] createDirectoryAtPath:WWFavoriteArticleCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [WWFavoriteArticleCachePath stringByAppendingPathComponent:[self md5:model.title]];
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

+ (void)archiveFavoriteAccount:(WWAccountModel *)model
{
    [[NSFileManager defaultManager] createDirectoryAtPath:WWFavoriteAccountCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [WWFavoriteAccountCachePath stringByAppendingPathComponent:[self md5:model.wxID]];
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

+ (void)removeFavoriteArticle:(WWArticleItemModel *)model
{
    NSString *path = [WWFavoriteArticleCachePath stringByAppendingPathComponent:[self md5:model.title]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (void)removeFavoriteAccount:(WWAccountModel *)model
{
    NSString *path = [WWFavoriteAccountCachePath stringByAppendingPathComponent:[self md5:model.wxID]];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (NSArray <WWArticleItemModel *> *)cacheFavoriteArticles
{
    NSMutableArray <WWArticleItemModel *> *articles = [NSMutableArray array];
    NSArray <NSString *> *files = [self allFilesAtPath:WWFavoriteArticleCachePath];
    if (files && files.count > 0) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WWArticleItemModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
            if (model && [model isKindOfClass:[WWArticleItemModel class]]) {
                [articles addObject:model];
            }
        }];
    }
    return articles&&articles.count>0 ? [articles copy]:nil;
}

+ (NSArray <WWAccountModel *> *)cacheFavoriteAccounts
{
    NSMutableArray <WWAccountModel *> *accounts = [NSMutableArray array];
    NSArray <NSString *> *files = [self allFilesAtPath:WWFavoriteAccountCachePath];
    if (files && files.count > 0) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WWAccountModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
            if (model && [model isKindOfClass:[WWAccountModel class]]) {
                [accounts addObject:model];
            }
        }];
    }
    return accounts&&accounts.count>0 ? [accounts copy]:nil;
}

+ (BOOL)hasCacheFavoriteArticle:(WWArticleItemModel *)model
{
    NSString *path = [WWFavoriteArticleCachePath stringByAppendingPathComponent:[self md5:model.title]];
    BOOL hasCache = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return hasCache;
}

+ (BOOL)hasCacheFavoriteAccount:(WWAccountModel *)model
{
    NSString *path = [WWFavoriteAccountCachePath stringByAppendingPathComponent:[self md5:model.wxID]];
    BOOL hasCache = [[NSFileManager defaultManager] fileExistsAtPath:path];
    return hasCache;
}

+ (NSArray *)allFilesAtPath:(NSString *)dirString
{
    NSMutableArray* array = [NSMutableArray array];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

#pragma mark - encrypt
+ (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

@end
