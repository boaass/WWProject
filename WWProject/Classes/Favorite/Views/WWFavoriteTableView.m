//
//  WWFavoriteTableView.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/25.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWFavoriteTableView.h"
#import "WWArticleTableViewCell.h"
#import "WWAccountTableViewCell.h"
#import "WWWebViewController.h"
#import "WWAccountMainPageViewController.h"
#import "WWArticleItemModel.h"
#import "WWArticleCacheModel.h"
#import "WWAccountModel.h"
#import "WWAccountCacheModel.h"
#import "MJRefresh.h"

@interface WWFavoriteTableView () <UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong, readwrite) NSArray *cellDatas;
@property (nonatomic, assign, readwrite) WWFavoriteType currentFavoriteType;

@end

@implementation WWFavoriteTableView

- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.dataSource = self;
        
        __weak typeof(self) weakSelf = self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.mj_header endRefreshing];
            [weakSelf reloadData];
        }];
    }
    return self;
}

#pragma mark - public
+ (instancetype)tableViewWithType:(WWFavoriteType)favoriteType
{
    WWFavoriteTableView *tableView = [[WWFavoriteTableView alloc] init];
    tableView.currentFavoriteType = favoriteType;
    return tableView;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWFavoriteTableView *view = (WWFavoriteTableView *)tableView;
    switch (view.currentFavoriteType) {
        case WWFavoriteArticleType:
        {
            return 100;
        }
            break;
        case WWFavoriteAccountType:
        {
            WWAccountModel *model = self.cellDatas[indexPath.row];
            WWAccountTableViewCell *cell = [WWAccountTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return [cell cellHeight];
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WWFavoriteTableView *view = (WWFavoriteTableView *)tableView;
    switch (view.currentFavoriteType) {
        case WWFavoriteArticleType:
        {
            WWArticleItemModel *model = self.cellDatas[indexPath.row];
            WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:model];
            WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:webVC];
            [self.superVC presentViewController:nav animated:YES completion:nil];
        }
            break;
        case WWFavoriteAccountType:
        {
            WWAccountModel *model = self.cellDatas[indexPath.row];
            WWAccountMainPageViewController *webVC = [WWAccountMainPageViewController accountMainPageWithAccountModel:model];
            WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:webVC];
            [self.superVC presentViewController:nav animated:YES completion:nil];
        }
            break;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWFavoriteTableView *view = (WWFavoriteTableView *)tableView;
    switch (view.currentFavoriteType) {
        case WWFavoriteArticleType:
        {
            WWArticleTableViewCell *cell = [WWArticleTableViewCell cellWithTableView:view];
            WWArticleItemModel *model = [self.cellDatas objectAtIndex:indexPath.row];
            cell.model = model;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
                // 3DTouch
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    [self.superVC registerForPreviewingWithDelegate:self sourceView:cell];
                }
            }
            return cell;
        }
            break;
        case WWFavoriteAccountType:
        {
            WWAccountTableViewCell *cell = [WWAccountTableViewCell cellWithTableView:view];
            WWAccountModel *model = [self.cellDatas objectAtIndex:indexPath.row];
            cell.model = model;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
                // 3DTouch
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    [self.superVC registerForPreviewingWithDelegate:self sourceView:cell];
                }
            }
            return cell;
        }
            break;
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    UIView *cell = [previewingContext sourceView];
    NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell *)cell];
    __weak typeof(self) weakSelf = self;
    if ([cell isKindOfClass:[WWArticleTableViewCell class]]) {
        WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:self.cellDatas[indexPath.row]];
        webVC.touchBlock = ^{
            [weakSelf reloadData];
        };
        return webVC;
    } else if ([cell isKindOfClass:[WWAccountTableViewCell class]]) {
        WWAccountModel *model = self.cellDatas[indexPath.row];
        WWAccountMainPageViewController *webVC = [WWAccountMainPageViewController accountMainPageWithAccountModel:model];
        webVC.touchBlock = ^{
            [weakSelf reloadData];
        };
        return webVC;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    UIView *cell = [previewingContext sourceView];
    NSIndexPath *indexPath = [self indexPathForCell:(UITableViewCell *)cell];
    if ([cell isKindOfClass:[WWArticleTableViewCell class]]) {
        WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:self.cellDatas[indexPath.row]];
        WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:webVC];
        [self.superVC showViewController:nav sender:self.superVC.navigationController];
    } else if ([cell isKindOfClass:[WWAccountTableViewCell class]]) {
        WWAccountModel *model = self.cellDatas[indexPath.row];
        WWAccountMainPageViewController *webVC = [WWAccountMainPageViewController accountMainPageWithAccountModel:model];
        WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:webVC];
        [self.superVC showViewController:nav sender:self.superVC.navigationController];
    }
}

#pragma mark - setter & getter
- (NSArray *)cellDatas
{
    NSMutableArray *datas = [NSMutableArray array];
    switch (self.currentFavoriteType) {
        case WWFavoriteArticleType:
        {
            NSArray *cacheDatas = [WWTools cacheFavoriteArticles];
            [cacheDatas enumerateObjectsUsingBlock:^(WWArticleCacheModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [datas addObject:obj.articleModel];
            }];
            _cellDatas = [datas copy];
            return datas;
        }
            break;
        case WWFavoriteAccountType:
        {
            NSArray *cacheDatas = [WWTools cacheFavoriteAccounts];
            [cacheDatas enumerateObjectsUsingBlock:^(WWAccountCacheModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [datas addObject:obj.accountModel];
            }];
            _cellDatas = [datas copy];
            return datas;
        }
            break;
    }
}

@end
