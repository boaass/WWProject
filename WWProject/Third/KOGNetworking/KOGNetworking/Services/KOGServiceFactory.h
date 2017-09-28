//
//  KOGServiceFactory.h
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KOGService.h"

@interface KOGServiceFactory : NSObject

+ (instancetype)sharedInstance;
- (KOGService<KOGServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier;

@end
