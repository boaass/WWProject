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

@interface RootTabBarViewController ()

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

@end
