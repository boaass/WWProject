//
//  WWArticleCacheModel.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/26.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWArticleCacheModel.h"
#import "WWArticleItemModel.h"

@implementation WWArticleCacheModel

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    WWArticleCacheModel *model = [[self class] allocWithZone:zone];
    model.articleModel = self.articleModel;
    model.cacheTimeStamp = self.cacheTimeStamp;
    return model;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.articleModel forKey:@"articleModel"];
    [aCoder encodeObject:self.cacheTimeStamp forKey:@"cacheTimeStamp"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _articleModel = [aDecoder decodeObjectForKey:@"articleModel"];
        _cacheTimeStamp = [aDecoder decodeObjectForKey:@"cacheTimeStamp"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{articleModel: %@, cacheTimeStamp: %@}", self.articleModel, self.cacheTimeStamp];
}

@end
