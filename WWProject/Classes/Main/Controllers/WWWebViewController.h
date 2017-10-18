//
//  WWWebViewController.h
//  WWProject
//
//  Created by zhai chunlin on 17/10/16.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WWWebViewControllerType) {
    WWWebViewControllerTypeAccount,
    WWWebViewControllerTypeArticle,
};

@class WWArticleItemModel;
@class WWAccountModel;
@interface WWWebViewController : UIViewController

@property (nonatomic, strong) WWAccountModel *accountModel;
@property (nonatomic, strong) WWArticleItemModel *articleModel;

+ (instancetype)webViewControllerWithType:(WWWebViewControllerType)type;

@end
