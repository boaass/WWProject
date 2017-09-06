//
//  MainTableViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "MainTableViewController.h"
#import "BannerView.h"
#import "XTSegmentControl.h"

@interface MainTableViewController ()

@property (nonatomic, strong) BannerView *bannerView;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self mm_setupHeaderView];
}


#pragma mark - TableDiewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 0;
}

#pragma mark - private
- (void)mm_refreshBannerView
{
    [self.bannerView reload];
}

- (void)mm_setupHeaderView
{
    self.tableView.tableHeaderView = self.bannerView;
}

#pragma mark - setter & getter
- (BannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * 214/640)];
        BannerData *data1 = [[BannerData alloc] init];
        data1.imageUrl = @"http://pic21.nipic.com/20120613/2471913_170711965000_2.jpg";
        BannerData *data2 = [[BannerData alloc] init];
        data2.imageUrl = @"http://pic35.photophoto.cn/20150601/0038038082361163_b.jpg";
        _bannerView.bannerList = @[data1, data2];
        _bannerView.tapBlock = ^(BannerData *bannerData) {
            NSLog(@"tap url: %@", bannerData.imageUrl);
        };
    }
    
    return _bannerView;
}

@end
