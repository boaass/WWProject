//
//  RootTabBarViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "RDVTabBarItem.h"
#import "MainViewController.h"
#import "FavoriteTableViewController.h"
#import "WWMainNavigationController.h"

@interface RootTabBarViewController ()

@property (nonatomic, strong) NSArray *titles;

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ww_setupChildrenVCs];
    [self ww_setupCustomTabBarItems];
}

#pragma mark - private
- (void)ww_setupChildrenVCs
{
    MainViewController *mainTVC = [[MainViewController alloc] init];
    mainTVC.title = [self.titles firstObject];
    WWMainNavigationController *mainNavController = [[WWMainNavigationController alloc] initWithRootViewController:mainTVC];
    FavoriteTableViewController *favoriteTVC = [[FavoriteTableViewController alloc] init];
    [self setViewControllers:@[mainNavController, favoriteTVC]];
}

- (void)ww_setupCustomTabBarItems
{
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setTitle:[self.titles objectAtIndex:index]];
        index++;
    }
}

- (NSArray *)titles
{
    if (!_titles) {
        _titles = [NSArray arrayWithObjects:@"发现", @"我的收藏", nil];
    }
    return _titles;
}

@end
