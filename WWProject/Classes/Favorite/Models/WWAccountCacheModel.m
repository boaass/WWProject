//
//  WWAccountCacheModel.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/26.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountCacheModel.h"
#import "WWAccountModel.h"

@implementation WWAccountCacheModel

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    WWAccountCacheModel *model = [[self class] allocWithZone:zone];
    model.accountModel = self.accountModel;
    model.cacheTimeStamp = self.cacheTimeStamp;
    return model;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.accountModel forKey:@"accountModel"];
    [aCoder encodeObject:self.cacheTimeStamp forKey:@"cacheTimeStamp"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _accountModel = [aDecoder decodeObjectForKey:@"accountModel"];
        _cacheTimeStamp = [aDecoder decodeObjectForKey:@"cacheTimeStamp"];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{account: %@, cacheTimeStamp: %@}", self.accountModel, self.cacheTimeStamp];
}

@end
