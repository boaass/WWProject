//
//  WWWebPopView.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/17.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWPopViewItemButton;
@interface WWWebPopView : UIView

@property (nonatomic, strong) NSArray <WWPopViewItemButton *> *buttonList;

+ (instancetype)webPopViewWithButtonList:(NSArray <WWPopViewItemButton *> *)buttonList;

- (void)show;

- (void)dissmiss;

@end
