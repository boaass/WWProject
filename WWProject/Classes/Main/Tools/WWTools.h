//
//  WWTools.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWTools : NSObject

+ (NSDictionary *)combinedParamsForRequestWithSearchUrl:(NSString *)searchUrl replaceString:(NSString *)replaceString;

@end
