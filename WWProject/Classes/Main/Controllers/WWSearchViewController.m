//
//  WWSearchViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWSearchViewController.h"
#import "WWAcountSearchAPIManager.h"
#import "WWSearchBar.h"
#import "WWAcountModel.h"
#import "KOGNetworkingConfiguration.h"
#import "WWSearchTableView.h"

@interface WWSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WWSearchTableView *tableView;
@property (nonatomic, strong) WWAcountSearchAPIManager *accountSearchManager;
@property (nonatomic, strong) NSArray *searchResult;
@property (nonatomic, strong) NSString *searchMethod;
@property (nonatomic, strong) NSDictionary *searchParams;

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
        
        [weakSelf ww_refreshData];
    }];
    self.navigationItem.titleView = searchBar;
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
    [weakSelf.accountSearchManager loadDataWithUrl:self.searchMethod params:self.searchParams block:^(WWAcountSearchAPIManager *manager) {
        if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
            weakSelf.searchResult = manager.accountInfos;
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)ww_loadMoreData
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.accountSearchManager nextPage:^(WWAcountSearchAPIManager *manager) {
        if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
            weakSelf.searchResult = [weakSelf.searchResult arrayByAddingObjectsFromArray:manager.accountInfos];
            [weakSelf.tableView reloadData];
        }
    }];
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
    WWAcountModel *model = self.searchResult[indexPath.row];
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = model.author;
    return cell;
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

- (NSArray *)searchResult
{
    if (!_searchResult) {
        _searchResult = [NSArray array];
    }
    return _searchResult;
}

@end
