//
//  RootTabBarViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "RDVTabBarItem.h"
#import "MainTableViewController.h"
#import "FavoriteTableViewController.h"
#import "WWMainPageAPIManager.h"

@interface RootTabBarViewController ()

@property (nonatomic, strong) WWMainPageAPIManager *manager;

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ww_setupChildrenVCs];
    [self ww_setupCustomTabBarItems];
    [self ww_loadData];
}

#pragma mark - private
- (void)ww_setupChildrenVCs
{
    MainTableViewController *mainTVC = [[MainTableViewController alloc] init];
    FavoriteTableViewController *favoriteTVC = [[FavoriteTableViewController alloc] init];
    [self setViewControllers:@[mainTVC, favoriteTVC]];
}

- (void)ww_setupCustomTabBarItems
{
    NSArray *tabBarItemTitles = @[@"发现", @"我的收藏"];
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setTitle:[tabBarItemTitles objectAtIndex:index]];
        index++;
    }
}

- (void)ww_loadData
{
    [self.manager loadDataWithBlock:^(KOGAPIBaseManager *manager) {
        
    }];
}

#pragma mark - getter & setter
- (WWMainPageAPIManager *)manager
{
    if (!_manager) {
        _manager = [[WWMainPageAPIManager alloc] init];
    }
    
    return _manager;
}

@end
