//
//  WWSearchViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWSearchViewController.h"
#import "WWAcountSearchAPIManager.h"
#import "WWArticleSearchAPIManager.h"
#import "WWSearchBar.h"
#import "WWAcountModel.h"
#import "WWArticleItemModel.h"
#import "KOGNetworkingConfiguration.h"
#import "WWSearchTableView.h"

@interface WWSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WWSearchTableView *tableView;
@property (nonatomic, strong) WWAcountSearchAPIManager *accountSearchManager;
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
    WWSearchBar *searchBar = [WWSearchBar searchBarWithBlock:^(WWSearchBar *searchBar) {
        switch (searchBar.searchType) {
            case WWAccountSearchType:
            {
                NSString *fullUrl = [[self.accountSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageService withString:@""] stringByAppendingString:searchBar.searchContent];
                [weakSelf ww_combinedParamsForRequestWithSearchUrl:fullUrl];
            }
                break;
            case WWArticleSearchType:
            {
                NSString *fullUrl = [[self.articleSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageService withString:@""] stringByAppendingString:searchBar.searchContent];
                [weakSelf ww_combinedParamsForRequestWithSearchUrl:fullUrl];
            }
                break;
        }
        
        if (weakSelf.currentType != searchBar.searchType) {
            weakSelf.searchResult = [NSArray array];
        }
        self.currentType = searchBar.searchType;
        [weakSelf ww_refreshData];
    }];
    self.navigationItem.titleView = searchBar;
    [self.navigationController.tabBarItem setTitlePositionAdjustment:UIOffsetMake(-self.navigationItem.titleView.x, 0)];
    
    UIBarButtonItem *rightBBItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBBItem;
}

- (void)ww_combinedParamsForRequestWithSearchUrl:(NSString *)searchUrl
{
    NSString *fullUrl = [searchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""];
    NSRange segRange = [fullUrl rangeOfString:@"?"];
    self.searchMethod = [fullUrl substringToIndex:segRange.location];
    NSString *paramsStr = [fullUrl substringFromIndex:segRange.location+1];
    NSDictionary *params = [paramsStr paramStringToDictionary];
    self.searchParams = params;
}

- (void)ww_setupTableView
{
    __weak typeof(self) weakSelf = self;
    self.tableView.pullDownRefreshBlock = ^{
        [weakSelf ww_refreshData];
    };
    
    self.tableView.pullUpRefreshBlock = ^{
        [weakSelf ww_loadMoreData];
    };
}

- (void)ww_refreshData
{
    __weak typeof(self) weakSelf = self;
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            [weakSelf.accountSearchManager loadDataWithUrl:self.searchMethod params:self.searchParams block:^(WWAcountSearchAPIManager *manager) {
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

- (void)ww_loadMoreData
{
    __weak typeof(self) weakSelf = self;
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            [weakSelf.accountSearchManager nextPage:^(WWAcountSearchAPIManager *manager) {
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
    return 50;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = @"";
    switch (self.currentType) {
        case WWAccountSearchType:
        {
            WWAcountModel *model = self.searchResult[indexPath.row];
            text = model.author;
        }
            break;
        case WWArticleSearchType:
        {
            WWArticleItemModel *model = self.searchResult[indexPath.row];
            text = model.title;
        }
            break;
    }
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = text;
    return cell;
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

- (WWAcountSearchAPIManager *)accountSearchManager
{
    if (!_accountSearchManager) {
        _accountSearchManager = [[WWAcountSearchAPIManager alloc] init];
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
