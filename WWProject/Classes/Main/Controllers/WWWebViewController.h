//
//  WWWebViewController.h
//  WWProject
//
//  Created by zhai chunlin on 17/10/16.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWArticleItemModel;
@interface WWWebViewController : UIViewController

+ (instancetype)webViewControllerWithModel:(WWArticleItemModel *)model;

@end
