//
//  WWPopViewItemButton.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/17.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonClickBlock)();

@interface WWPopViewItemButton : UIView

+ (instancetype)buttonWithImageName:(NSString *)imageName
                              title:(NSString *)title
                         clickBlock:(ButtonClickBlock)clickBlock;

@end
