//
//  WWSearchViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWSearchViewController.h"
#import "WWAccountSearchAPIManager.h"
#import "WWArticleSearchAPIManager.h"
#import "WWSearchBar.h"
#import "WWAccountModel.h"
#import "WWArticleItemModel.h"
#import "KOGNetworkingConfiguration.h"
#import "WWSearchTableView.h"
#import "WWAccountTableViewCell.h"
#import "WWArticleTableViewCell.h"
#import "WWWebViewController.h"
#import "WWAccountMainPageViewController.h"

@interface WWSearchViewController () <UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) WWSearchTableView *tableView;
@property (nonatomic, strong) WWSearchBar *searchBar;
@property (nonatomic, strong) WWAccountSearchAPIManager *accountSearchManager;
@property (nonatomic, strong) WWArticleSearchAPIManager *articleSearchManager;
@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, strong) NSString *searchMethod;
@property (nonatomic, strong) NSDictionary *searchParams;
@property (nonatomic, assign) WWSearchType currentType;

@end

@implementation WWSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self ww_setupNavigationBarItem];
    [self ww_setupTableView];
}

#pragma mark - private
- (void)ww_setupNavigationBarItem
{
    __weak typeof(self) weakSelf = self;
    self.searchBar = [WWSearchBar searchBarWithBlock:^(WWSearchBar *searchBar) {
        NSDictionary *requestParam = nil;
        switch (searchBar.searchType) {
            case WWAccountSearchType:
            {
                NSString *fullUrl = [[self.accountSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""] stringByAppendingString:searchBar.searchContent];
                requestParam = [WWTools combinedParamsForRequestWithSearchUrl:fullUrl replaceString:kWWMainPageServiceOnlineApiBaseUrl];
            }
                break;
            case WWArticleSearchType:
            {
                NSString *fullUrl = [[self.articleSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""] stringByAppendingString:searchBar.searchContent];
                requestParam = [WWTools combinedParamsForRequestWithSearchUrl:fullUrl replaceString:kWWMainPageServiceOnlineApiBaseUrl];
            }
                break;
        }
        self.searchMethod = [[requestParam allKeys] firstObject];
        self.searchParams = [[requestParam allValues] firstObject];
        if (weakSelf.currentType != searchBar.searchType) {
            weakSelf.searchResult = [NSArray array];
        }
        self.currentType = searchBar.searchType;
        [weakSelf ww_refreshData];
    }];
    self.navigationItem.titleView = self.searchBar;
    [self.navigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-self.navigationItem.titleView.x, 0)];
    
    UIBarButtonItem *rightBBItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBBItem;
}

- (void)ww_setupTableView
{
    __weak typeof(self) weakSelf = self;
    self.tableView.pullDownRefreshBlock = ^(WWSearchTableView *tableView){
        [weakSelf ww_refreshData];
        [tableView endRefreshingHeader];
    };
    
    self.tableView.pullUpRefreshBlock = ^(WWSearchTableView *tableView){
        [weakSelf ww_loadMoreData:^(BOOL hasData) {
            [tableView endRefreshingFooter:hasData];
        }];
    };
}

- (void)ww_refreshData
{
    __weak typeof(self) weakSelf = self;
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            [weakSelf.accountSearchManager loadDataWithUrl:self.searchMethod params:self.searchParams block:^(WWAccountSearchAPIManager *manager) {
                if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                    weakSelf.searchResult = manager.accountInfos;
                    [weakSelf.tableView reloadData];
                }
            }];
        }
            break;
        case WWArticleSearchType:
        {
            [weakSelf.articleSearchManager loadDataWithUrl:self.searchMethod params:self.searchParams block:^(WWArticleSearchAPIManager *manager) {
                if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                    weakSelf.searchResult = manager.articleInfos;
                    [weakSelf.tableView reloadData];
                }
            }];
        }
            break;
    }
}

- (void)ww_loadMoreData:(void (^)(BOOL hasData))block
{
    __weak typeof(self) weakSelf = self;
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            [weakSelf.accountSearchManager nextPage:^(WWAccountSearchAPIManager *manager) {
                if (!manager.accountInfos || manager.accountInfos.count == 0) {
                    block(NO);
                    return;
                } else {
                    block(YES);
                }
                
                if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                    weakSelf.searchResult = [weakSelf.searchResult arrayByAddingObjectsFromArray:manager.accountInfos];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
            break;
        case WWArticleSearchType:
        {
            [weakSelf.articleSearchManager nextPage:^(WWArticleSearchAPIManager *manager) {
                if (!manager.articleInfos || manager.articleInfos.count == 0) {
                    block(YES);
                    return;
                } else {
                    block(NO);
                }
                
                if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                    weakSelf.searchResult = [weakSelf.searchResult arrayByAddingObjectsFromArray:manager.articleInfos];
                    [weakSelf.tableView reloadData];
                }
            }];
        }
            break;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentType == WWAccountSearchType) {
        WWAccountModel *model = self.searchResult[indexPath.row];
        WWAccountTableViewCell *cell = [WWAccountTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return [cell cellHeight];
    } else {
        return 100;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            WWAccountModel *model = self.searchResult[indexPath.row];
            WWAccountMainPageViewController *webVC = [WWAccountMainPageViewController accountMainPageWithAccountModel:model];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case WWArticleSearchType:
        {
            WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:self.searchResult[indexPath.row]];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            WWAccountModel *model = self.searchResult[indexPath.row];
            WWAccountTableViewCell *cell = [WWAccountTableViewCell cellWithTableView:tableView];
            cell.model = model;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
                // 3DTouch
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    [self registerForPreviewingWithDelegate:self sourceView:cell];
                }
            }
            return cell;
        }
            break;
        case WWArticleSearchType:
        {
            WWArticleItemModel *model = self.searchResult[indexPath.row];
            WWArticleTableViewCell *cell = [WWArticleTableViewCell cellWithTableView:tableView];
            cell.model = model;
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9")) {
                // 3DTouch
                if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                    [self registerForPreviewingWithDelegate:self sourceView:cell];
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
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)cell];
    if ([cell isKindOfClass:[WWArticleTableViewCell class]]) {
        WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:self.searchResult[indexPath.row]];
        return webVC;
    } else if ([cell isKindOfClass:[WWAccountTableViewCell class]]) {
        WWAccountModel *model = self.searchResult[indexPath.row];
        WWAccountMainPageViewController *webVC = [WWAccountMainPageViewController accountMainPageWithAccountModel:model];
        return webVC;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    UIView *cell = [previewingContext sourceView];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)cell];
    if ([cell isKindOfClass:[WWArticleTableViewCell class]]) {
        WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:self.searchResult[indexPath.row]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
        [self showViewController:nav sender:self.navigationController];
    } else if ([cell isKindOfClass:[WWAccountTableViewCell class]]) {
        WWAccountModel *model = self.searchResult[indexPath.row];
        WWAccountMainPageViewController *webVC = [WWAccountMainPageViewController accountMainPageWithAccountModel:model];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
        [self showViewController:nav sender:self.navigationController];
    }
}

#pragma mark - action
- (void)rightBarButtonAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter & getter
- (WWSearchTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[WWSearchTableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = self.view.bounds;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (WWAccountSearchAPIManager *)accountSearchManager
{
    if (!_accountSearchManager) {
        _accountSearchManager = [[WWAccountSearchAPIManager alloc] init];
    }
    return _accountSearchManager;
}

- (WWArticleSearchAPIManager *)articleSearchManager
{
    if (!_articleSearchManager) {
        _articleSearchManager = [[WWArticleSearchAPIManager alloc] init];
    }
    return _articleSearchManager;
}

- (NSArray *)searchResult
{
    if (!_searchResult) {
        _searchResult = [NSArray array];
    }
    return _searchResult;
}

@end
