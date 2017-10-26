//
//  WWWebViewController.h
//  WWProject
//
//  Created by zhai chunlin on 17/10/16.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWArticleItemModel;

typedef void(^WWWebVC3DTouchBlock)();

@interface WWWebViewController : UIViewController

@property (nonatomic, assign) BOOL isOpened;
@property (nonatomic, strong, readonly) WWArticleItemModel *articleModel;
@property (nonatomic, strong) WWWebVC3DTouchBlock touchBlock;

+ (instancetype)webViewControllerWithArticleModel:(WWArticleItemModel *)model;

@end
