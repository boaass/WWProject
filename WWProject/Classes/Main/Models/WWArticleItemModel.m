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
    model.wxID = self.wxID;
    model.timeStamp = self.timeStamp;
    model.overview = self.overview;
    model.contentUrl = self.contentUrl;
    model.authorMainUrl = self.authorMainUrl;
    
    return model;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_bigImageUrl forKey:@"bigImageUrl"];
    [aCoder encodeObject:_author forKey:@"author"];
    [aCoder encodeObject:_wxID forKey:@"wxID"];
    [aCoder encodeObject:_timeStamp forKey:@"timeStamp"];
    [aCoder encodeObject:_overview forKey:@"overview"];
    [aCoder encodeObject:_contentUrl forKey:@"contentUrl"];
    [aCoder encodeObject:_authorMainUrl forKey:@"authorMainUrl"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _bigImageUrl = [aDecoder decodeObjectForKey:@"bigImageUrl"];
        _author = [aDecoder decodeObjectForKey:@"author"];
        _wxID = [aDecoder decodeObjectForKey:@"wxID"];
        _timeStamp = [aDecoder decodeObjectForKey:@"timeStamp"];
        _overview = [aDecoder decodeObjectForKey:@"overview"];
        _contentUrl = [aDecoder decodeObjectForKey:@"contentUrl"];
        _authorMainUrl = [aDecoder decodeObjectForKey:@"authorMainUrl"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{title:%@, bigImageUrl:%@, author:%@, wxID:%@, timeStamp:%@, overview:%@, contentUrl:%@, authorMainUrl:%@}", self.title, self.bigImageUrl, self.author, self.wxID, self.timeStamp, self.overview, self.contentUrl, self.authorMainUrl];
}

@end
