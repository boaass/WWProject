//
//  WWTagTableView.m
//  WWProject
//
//  Created by zhai chunlin on 17/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWTagTableView.h"
#import "WWMainPageTagInfoManager.h"
#import "WWArticleItemModel.h"
#import "WWArticleTableViewCell.h"
#import "MJRefresh.h"
#import "WWWebViewController.h"

@interface WWTagTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *articleInfo;
@property (nonatomic, strong) WWMainPageTagInfoManager *manager;

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
    [self.manager loadDataWithUrl:self.methodName params:(NSDictionary *)params block:^(WWMainPageTagInfoManager *manager) {
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer resetNoMoreData];
        weakSelf.articleInfo = manager.articleInfo;
        [weakSelf reloadData];
    }];
}

#pragma mark - private
- (void)ww_loadNext
{
    __weak typeof(self) weakSelf = self;
    [self.manager nextPage:^(WWMainPageTagInfoManager *manager) {
        if (!manager.articleInfo || manager.articleInfo.count == 0) {
            [weakSelf.mj_footer endRefreshingWithNoMoreData];
            return ;
        } else {
            [weakSelf.mj_footer endRefreshing];
        }
        weakSelf.articleInfo = [weakSelf.articleInfo arrayByAddingObjectsFromArray:manager.articleInfo];
        [weakSelf reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WWArticleItemModel *model = self.articleInfo[indexPath.row];
    WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:model];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self.superVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWArticleTableViewCell *cell = [WWArticleTableViewCell cellWithTableView:tableView];
    WWArticleItemModel *model = self.articleInfo[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - setter & getter
- (WWMainPageTagInfoManager *)manager
{
    if (!_manager) {
        _manager = [[WWMainPageTagInfoManager alloc] init];
    }
    
    return _manager;
}

@end
