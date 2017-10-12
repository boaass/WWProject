//
//  WWTagTableView.m
//  WWProject
//
//  Created by zhai chunlin on 17/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWTagTableView.h"
#import "WWArticleInfoManager.h"
#import "WWArticleItemModel.h"
#import "WWMainTableViewCell.h"
#import "MJRefresh.h"

@interface WWTagTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *articleInfo;
@property (nonatomic, strong) WWArticleInfoManager *manager;

@end

@implementation WWTagTableView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
        
        __weak typeof(self) weakSelf = self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadWithMethodName:weakSelf.methodName params:self.params];
        }];
        
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf ww_loadNext];
        }];
    }
    
    return self;
}

#pragma mark - public
- (void)loadWithMethodName:(NSString *)methodName params:(NSDictionary *)params
{
    self.methodName = methodName;
    self.params = params;
    
    __weak typeof(self) weakSelf = self;
    [self.manager loadDataWithUrl:self.methodName params:(NSDictionary *)params block:^(WWArticleInfoManager *manager) {
        [weakSelf.mj_header endRefreshing];
        weakSelf.articleInfo = manager.articleInfo;
        [weakSelf reloadData];
    }];
}

#pragma mark - private
- (void)ww_loadNext
{
    __weak typeof(self) weakSelf = self;
    [self.manager nextPage:^(WWArticleInfoManager *manager) {
        [weakSelf.mj_footer endRefreshing];
        weakSelf.articleInfo = [weakSelf.articleInfo arrayByAddingObjectsFromArray:manager.articleInfo];
        [weakSelf reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWMainTableViewCell *cell = [WWMainTableViewCell cellWithTableView:tableView];
    WWArticleItemModel *model = self.articleInfo[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - setter & getter
- (WWArticleInfoManager *)manager
{
    if (!_manager) {
        _manager = [[WWArticleInfoManager alloc] init];
    }
    
    return _manager;
}

@end
