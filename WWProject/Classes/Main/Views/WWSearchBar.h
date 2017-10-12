//
//  WWSearchBar.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWSearchBar;

typedef enum : NSUInteger {
    WWAccountSearchType,
    WWArticleSearchType,
} WWSearchType;

typedef void(^SearchBarEndEditBlcok)(WWSearchBar *);

@interface WWSearchBar : UITextField

@property (nonatomic, strong, readonly) NSString *searchContent;
@property (nonatomic, assign, readonly) WWSearchType searchType;

+ (instancetype)searchBarWithBlock:(SearchBarEndEditBlcok)block;

@end
