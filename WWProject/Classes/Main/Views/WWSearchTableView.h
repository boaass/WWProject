//
//  WWSearchTableView.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/12.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWSearchTableView;
typedef void (^WWSearchTableViewPullDownRefreshBlock)(WWSearchTableView *);
typedef void (^WWSearchTableViewPullUpRefreshBlock)(WWSearchTableView *);

@interface WWSearchTableView : UITableView

@property (nonatomic, strong) WWSearchTableViewPullDownRefreshBlock pullDownRefreshBlock;
@property (nonatomic, strong) WWSearchTableViewPullUpRefreshBlock pullUpRefreshBlock;

- (void)endRefreshingHeader;
- (void)endRefreshingFooter:(BOOL)hasData;

@end
