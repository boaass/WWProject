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

@interface WWSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WWAcountSearchAPIManager *accountSearchManager;

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
            {
                self.articleSearchUrl
            }
                break;
            case WWArticleSearchType:
                
                break;
        }
        [weakSelf.accountSearchManager loadDataWithUrl:<#(NSString *)#> block:<#^(WWAcountSearchAPIManager *)block#>]
    }];
    self.navigationItem.titleView = searchBar;
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

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

@end
