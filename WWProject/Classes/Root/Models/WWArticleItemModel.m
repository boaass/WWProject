//
//  WWArticleItemModel.m
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWArticleItemModel.h"

@implementation WWArticleItemModel

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    WWArticleItemModel *model = [[[self class] allocWithZone:zone] init];
    model.title = self.title;
    model.bigImageUrl = self.bigImageUrl;
    model.author = self.author;
    model.time = self.time;
    model.overview = self.overview;
    model.contentUrl = self.contentUrl;
    
    return model;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_bigImageUrl forKey:@"bigImageUrl"];
    [aCoder encodeObject:_author forKey:@"author"];
    [aCoder encodeObject:_time forKey:@"time"];
    [aCoder encodeObject:_overview forKey:@"overview"];
    [aCoder encodeObject:_contentUrl forKey:@"contentUrl"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _bigImageUrl = [aDecoder decodeObjectForKey:@"bigImageUrl"];
        _author = [aDecoder decodeObjectForKey:@"author"];
        _time = [aDecoder decodeObjectForKey:@"time"];
        _overview = [aDecoder decodeObjectForKey:@"overview"];
        _contentUrl = [aDecoder decodeObjectForKey:@"contentUrl"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{title:%@, bigImageUrl:%@, author:%@, time:%@, overview:%@, contentUrl:%@}", self.title, self.bigImageUrl, self.author, self.time, self.overview, self.contentUrl];;
}

@end
