//
//  WWArticleInfoManager.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWArticleInfoManager;
@class WWArticleItemModel;

typedef void(^CompleteBlock)(WWArticleInfoManager *);

@interface WWArticleInfoManager : KOGAPIBaseManager

@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSArray <WWArticleItemModel *> *articleInfo;

- (void)loadDataWithUrl:(NSString *)methodName block:(CompleteBlock)block;

- (void)nextPage;

@end
