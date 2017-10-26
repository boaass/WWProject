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

@interface WWTagTableView () <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *articleInfos;
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
        weakSelf.articleInfos = manager.articleInfos;
        [weakSelf reloadData];
    }];
}

#pragma mark - private
- (void)ww_loadNext
{
    __weak typeof(self) weakSelf = self;
    [self.manager nextPage:^(WWMainPageTagInfoManager *manager) {
        if (!manager.articleInfos || manager.articleInfos.count == 0) {
            [weakSelf.mj_footer endRefreshingWithNoMoreData];
            return ;
        } else {
            [weakSelf.mj_footer endRefreshing];
        }
        weakSelf.articleInfos = [weakSelf.articleInfos arrayByAddingObjectsFromArray:manager.articleInfos];
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
    
    WWArticleItemModel *model = self.articleInfos[indexPath.row];
    WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:model];
    WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:webVC];
    [self.superVC presentViewController:nav animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleInfos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWArticleTableViewCell *cell = [WWArticleTableViewCell cellWithTableView:tableView];
    WWArticleItemModel *model = self.articleInfos[indexPath.row];
    cell.model = model;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
        // 3DTouch
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self.superVC registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    return cell;
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:[self.articleInfos objectAtIndex:indexPath.row]];
    return webVC;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
    WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:[self.articleInfos objectAtIndex:indexPath.row]];
    WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:webVC];
    [self.superVC showViewController:nav sender:self];
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
