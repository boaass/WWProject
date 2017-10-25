//
//  WWAccountMainPageAPIManager
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWAccountMainPageAPIManager;
@class WWArticleItemModel;
@class WWAccountModel;

typedef void(^AccountMainPageInfoCompleteBlock)(WWAccountMainPageAPIManager *manager);

@interface WWAccountMainPageAPIManager : KOGAPIBaseManager

@property (nonatomic, strong, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSArray <WWArticleItemModel *> *articleInfos;
@property (nonatomic, strong, readonly) WWAccountModel *accountInfo;
// 必传
@property (nonatomic, strong) NSString *authorMainPageUrl;

- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(AccountMainPageInfoCompleteBlock)block;

@end
