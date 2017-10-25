//
//  WWAccountModel.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountModel.h"

@implementation WWAccountModel

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    WWAccountModel *model = [[self class] allocWithZone:zone];
    model.author = self.author;
    model.authorMainUrl = self.authorMainUrl;
    model.wxID = self.wxID;
    model.iconUrl = self.iconUrl;
    model.descriptions = self.descriptions;
    return model;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_author forKey:@"author"];
    [aCoder encodeObject:_authorMainUrl forKey:@"authorMainUrl"];
    [aCoder encodeObject:_wxID forKey:@"wxID"];
    [aCoder encodeObject:_iconUrl forKey:@"iconUrl"];
    [aCoder encodeObject:_descriptions forKey:@"descriptions"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _author = [aDecoder decodeObjectForKey:@"author"];
        _authorMainUrl = [aDecoder decodeObjectForKey:@"authorMainUrl"];
        _wxID = [aDecoder decodeObjectForKey:@"wxID"];
        _iconUrl = [aDecoder decodeObjectForKey:@"iconUrl"];
        _descriptions = [aDecoder decodeObjectForKey:@"descriptions"];
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{author:%@, authorMainUrl:%@, wxID:%@, iconUrl:%@, descriptions:%@}", self.author, self.authorMainUrl, self.wxID, self.iconUrl, self.descriptions];
}

@end
