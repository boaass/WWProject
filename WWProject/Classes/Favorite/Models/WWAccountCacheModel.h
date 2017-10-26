//
//  WWAccountCacheModel.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/26.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WWAccountModel;
@interface WWAccountCacheModel : NSObject

@property (nonatomic, strong) WWAccountModel *accountModel;
@property (nonatomic, strong) NSString *cacheTimeStamp;

@end
