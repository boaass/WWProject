//
//  WWMainPageAPIManager.h
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"


typedef void(^CompleteBlock)(KOGAPIBaseManager *);
@interface WWMainPageAPIManager : KOGAPIBaseManager

- (void)loadDataWithBlock:(CompleteBlock)block;

@end
