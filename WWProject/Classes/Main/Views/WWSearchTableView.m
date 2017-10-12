//
//  WWSearchTableView.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/12.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWSearchTableView.h"
#import "MJRefresh.h"

@interface WWSearchTableView ()

@end

@implementation WWSearchTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        __weak typeof(self) weakSelf = self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (weakSelf.pullDownRefreshBlock) {
                weakSelf.pullDownRefreshBlock();
            }
            [weakSelf.mj_header endRefreshing];
        }];
        
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.pullUpRefreshBlock) {
                weakSelf.pullUpRefreshBlock();
            }
            [weakSelf.mj_footer endRefreshing];
        }];
    }
    return self;
}

@end
