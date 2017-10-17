//
//  BannerView.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWArticleItemModel;
@interface BannerView : UIView

@property (nonatomic, strong) NSArray <WWArticleItemModel *> * articleModelList;

@property (nonatomic, copy) void (^tapBlock)(WWArticleItemModel *model);

- (void)reload;

@end
