//
//  WWMainPageAPIManager.h
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"

@class WWMainPageAPIManager;
@class WWMainPageModel;

typedef void(^CompleteBlock)(WWMainPageAPIManager *);

@interface WWMainPageAPIManager : KOGAPIBaseManager

@property (nonatomic, strong) WWMainPageModel *model;

- (void)loadDataWithBlock:(CompleteBlock)block;

@end
