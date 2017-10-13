//
//  WWAccountSearchAPIManager.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWAccountSearchAPIManager;
@class WWAccountModel;

typedef void(^AccountInfoCompleteBlock)(WWAccountSearchAPIManager *);

@interface WWAccountSearchAPIManager : KOGAPIBaseManager

@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSArray <WWAccountModel *> *accountInfos;

- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(AccountInfoCompleteBlock)block;

- (void)nextPage:(AccountInfoCompleteBlock)block;

@end
