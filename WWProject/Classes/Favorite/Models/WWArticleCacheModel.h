//
//  WWArticleCacheModel.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/26.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WWArticleItemModel;
@interface WWArticleCacheModel : NSObject

@property (nonatomic, strong) WWArticleItemModel *articleModel;
@property (nonatomic, strong) NSString *cacheTimeStamp;

@end
