//
//  WWTagTableView.h
//  WWProject
//
//  Created by zhai chunlin on 17/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWTagTableView : UITableView

@property (nonatomic, strong) UIViewController *superVC;
- (void)loadWithMethodName:(NSString *)methodName params:(NSDictionary *)params;

@end
