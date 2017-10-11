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

@interface WWSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WWAcountSearchAPIManager *accountSearchManager;
@property (nonatomic, strong) NSArray *searchResult;

@end

@implementation WWSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ww_setupNavigationBarItem];
}

#pragma mark - private
- (void)ww_setupNavigationBarItem
{
    __weak typeof(self) weakSelf = self;
    WWSearchBar *searchBar = [WWSearchBar searchBarWithBlock:^(WWSearchBar *searchBar) {
        NSString *searchMethod = nil;
        switch (searchBar.searchType) {
            case WWAuthorSearchType:
                searchMethod = [[self.accountSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""] stringByAppendingString:searchBar.searchContent];
                break;
            case WWArticleSearchType:
                searchMethod = [[self.articleSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""] stringByAppendingString:searchBar.searchContent];
                break;
        }
        [weakSelf.accountSearchManager loadDataWithUrl:searchMethod block:^(WWAcountSearchAPIManager *manager) {
            if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                weakSelf.searchResult = manager.accountInfos;
            }
        }];
    }];
    self.navigationItem.titleView = searchBar;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    return nil;
//}

#pragma mark - setter & getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
