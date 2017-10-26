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
#import "WWArticleCacheModel.h"
#import "WWAccountCacheModel.h"
#import "WWArticleSearchAPIManager.h"
#import "WWAccountSearchAPIManager.h"

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
+ (void)archiveFavoriteArticle:(WWArticleCacheModel *)model
{
    [[NSFileManager defaultManager] createDirectoryAtPath:WWFavoriteArticleCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [WWFavoriteArticleCachePath stringByAppendingPathComponent:[self md5:model.articleModel.title]];
    [NSKeyedArchiver archiveRootObject:model toFile:path];
}

+ (void)archiveFavoriteAccount:(WWAccountCacheModel *)model
{
    [[NSFileManager defaultManager] createDirectoryAtPath:WWFavoriteAccountCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *path = [WWFavoriteAccountCachePath stringByAppendingPathComponent:[self md5:model.accountModel.wxID]];
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

+ (NSArray <WWArticleCacheModel *> *)cacheFavoriteArticles
{
    NSMutableArray <WWArticleCacheModel *> *articles = [NSMutableArray array];
    NSArray <NSString *> *files = [self allFilesAtPath:WWFavoriteArticleCachePath];
    if (files && files.count > 0) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WWArticleCacheModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
            if (model && [model isKindOfClass:[WWArticleCacheModel class]]) {
                [articles addObject:model];
            }
        }];
    }
    
    [articles sortUsingComparator:^NSComparisonResult(WWArticleCacheModel *obj1, WWArticleCacheModel *obj2) {
        return obj1.cacheTimeStamp.doubleValue < obj2.cacheTimeStamp.doubleValue;
    }];
    
    return articles&&articles.count>0 ? [articles copy]:nil;
}

+ (NSArray <WWAccountCacheModel *> *)cacheFavoriteAccounts
{
    NSMutableArray <WWAccountCacheModel *> *accounts = [NSMutableArray array];
    NSArray <NSString *> *files = [self allFilesAtPath:WWFavoriteAccountCachePath];
    if (files && files.count > 0) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WWAccountCacheModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
            if (model && [model isKindOfClass:[WWAccountCacheModel class]]) {
                [accounts addObject:model];
            }
        }];
    }
    [accounts sortUsingComparator:^NSComparisonResult(WWAccountCacheModel *obj1, WWAccountCacheModel *obj2) {
        return obj1.cacheTimeStamp.doubleValue < obj2.cacheTimeStamp.doubleValue;
    }];
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

+ (void)refreshCacheFavoriteArticleWithBlcok:(void (^)())block
{
    static int invalidCount = 0;
    static int validCount = 0;
    invalidCount = 0;
    validCount = 0;
    NSArray <NSString *> *files = [self allFilesAtPath:WWFavoriteArticleCachePath];
    __weak typeof(self) weakSelf = self;
    if (files && files.count > 0) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WWArticleCacheModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
            if (model && [model isKindOfClass:[WWArticleCacheModel class]]) {
                NSDictionary *requestData = [self combinedParamsForRequestWithSearchUrl:model.articleModel.contentUrl replaceString:kWWWXServiceOnlineApiBaseUrl];
                NSString *timeStamp = [[requestData allValues].firstObject objectForKey:@"timestamp"];
                if ([weakSelf hasExpiredWithTimeStamp:timeStamp]) {
                    // 超时无效
                    WWArticleSearchAPIManager *manager = [[WWArticleSearchAPIManager alloc] init];
                    [manager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWArticleSearchAPIManager *manager) {
                        if (manager.articleInfos && manager.articleInfos.count>0) {
                            WWArticleCacheModel *cacheModel = [[WWArticleCacheModel alloc] init];
                            WWArticleItemModel *rModel = manager.articleInfos.firstObject;
                            cacheModel.articleModel = rModel;
                            cacheModel.cacheTimeStamp = model.cacheTimeStamp;
                            [weakSelf archiveFavoriteArticle:cacheModel];
                            validCount++;
                            
                            if (validCount == files.count-invalidCount) {
                                if (block) {
                                    block();
                                }
                            }
                        }
                    }];
                } else {
                    validCount++;
                    if (validCount == files.count-invalidCount) {
                        if (block) {
                            block();
                        }
                    }
                }
            } else {
                invalidCount++;
            }
        }];
    }
}

+ (void)refreshCacheFavoriteAccountWithBlock:(void (^)())block
{
    static int invalidCount = 0;
    static int validCount = 0;
    invalidCount = 0;
    validCount = 0;
    NSArray <NSString *> *files = [self allFilesAtPath:WWFavoriteAccountCachePath];
    __weak typeof(self) weakSelf = self;
    if (files && files.count > 0) {
        [files enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WWAccountCacheModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:obj];
            if (model && [model isKindOfClass:[WWAccountCacheModel class]]) {
                NSDictionary *requestData = [self combinedParamsForRequestWithSearchUrl:model.accountModel.authorMainUrl replaceString:kWWWXServiceOnlineApiBaseUrl];
                NSString *timeStamp = [[requestData allValues].firstObject objectForKey:@"timestamp"];
                if ([weakSelf hasExpiredWithTimeStamp:timeStamp]) {
                    // 超时无效
                    WWAccountSearchAPIManager *manager = [[WWAccountSearchAPIManager alloc] init];
                    [manager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWAccountSearchAPIManager *manager) {
                        if (manager.accountInfos && manager.accountInfos.count>0) {
                            WWAccountCacheModel *cacheModel = [[WWAccountCacheModel alloc] init];
                            WWAccountModel *rModel = manager.accountInfos.firstObject;
                            cacheModel.accountModel = rModel;
                            cacheModel.cacheTimeStamp = model.cacheTimeStamp;
                            [weakSelf archiveFavoriteAccount:cacheModel];
                            validCount++;
                            if (validCount == files.count-invalidCount) {
                                if (block) {
                                    block();
                                }
                            }
                        }
                    }];
                } else {
                    validCount++;
                    if (validCount == files.count-invalidCount) {
                        if (block) {
                            block();
                        }
                    }
                }
            } else {
                invalidCount++;
            }
        }];
    }
}

+ (BOOL)hasExpiredWithTimeStamp:(NSString *)timeStamp
{
    NSDate *currentDate = [NSDate date];
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitHour fromDate:lastDate toDate:currentDate options:NSCalendarMatchStrictly];
    if (cmps.hour >= 12) {
        return YES;
    }
    return NO;
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
