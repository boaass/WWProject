//
//  WWAccountMainPageViewController.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWAccountModel;
typedef void(^WWAccountMainPageVC3DTouchBlock)();
@interface WWAccountMainPageViewController : UIViewController

@property (nonatomic, strong, readonly) WWAccountModel *accounteModel;
@property (nonatomic, strong) WWAccountMainPageVC3DTouchBlock touchBlock;

+ (instancetype)accountMainPageWithAccountModel:(WWAccountModel *)accounteModel;

@end
