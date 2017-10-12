//
//  WWAcountSearchAPIManager.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWAcountSearchAPIManager;
@class WWAcountModel;

typedef void(^CompleteBlock)(WWAcountSearchAPIManager *);

@interface WWAcountSearchAPIManager : KOGAPIBaseManager

@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSArray <WWAcountModel *> *accountInfos;

- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(CompleteBlock)block;

- (void)nextPage:(CompleteBlock)block;

@end
