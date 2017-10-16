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
                weakSelf.pullDownRefreshBlock(weakSelf);
            }
        }];
        
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.pullUpRefreshBlock) {
                weakSelf.pullUpRefreshBlock(weakSelf);
            }
        }];
        self.mj_footer.automaticallyHidden = YES;
    }
    return self;
}

- (void)endRefreshingHeader
{
    [self.mj_header endRefreshing];
    [self.mj_footer resetNoMoreData];
}

- (void)endRefreshingFooter:(BOOL)hasData
{
    if (hasData) {
        [self.mj_footer endRefreshing];
    } else {
        [self.mj_footer endRefreshingWithNoMoreData];
    }
}

@end
