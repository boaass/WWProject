//
//  WWSearchTableView.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/12.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WWSearchTableViewPullDownRefreshBlock)();
typedef void(^WWSearchTableViewPullUpRefreshBlock)();

@interface WWSearchTableView : UITableView

@property (nonatomic, strong) WWSearchTableViewPullDownRefreshBlock pullDownRefreshBlock;
@property (nonatomic, strong) WWSearchTableViewPullUpRefreshBlock pullUpRefreshBlock;

@end
