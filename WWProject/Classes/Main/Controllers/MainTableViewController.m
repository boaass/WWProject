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
#import "iCarousel.h"

@interface MainTableViewController () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) BannerView *bannerView;
@property (nonatomic, strong) XTSegmentControl *segmentControl;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSArray *articleInfoList;

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

#pragma mark - iCarouselDelegate
- (void)carouselDidScroll:(iCarousel *)carousel
{
    if (self.segmentControl) {
        float offset = carousel.scrollOffset;
        if (offset > 0) {
            [self.segmentControl moveIndexWithProgress:offset];
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    if (self.segmentControl) {
        self.segmentControl.currentIndex = carousel.currentItemIndex;
    }
    
    [carousel.visibleItemViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSubScrollsToTop:obj == carousel.currentItemView];
    }];
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.articleInfoList.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (label) {
        label.text = self.articleInfoList[index];
    } else {
        label = [[UILabel alloc] initWithFrame:carousel.bounds];
        label.text = self.articleInfoList[index];
    }
    
    [label setSubScrollsToTop:index == carousel.currentItemIndex];
    return label;
}

#pragma mark - private
- (void)mm_refreshBannerView
{
    [self.bannerView reload];
}

- (void)mm_setupHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.bannerView.height+self.segmentControl.height)];
    [view addSubview:self.bannerView];
    [view addSubview:self.segmentControl];
    self.tableView.tableHeaderView = view;
    
    [self.carousel reloadData];
}

#pragma mark - setter & getter
- (NSArray *)articleInfoList
{
    if (!_articleInfoList) {
        _articleInfoList = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4",  @"5", @"6", @"7", nil];
    }
    
    return _articleInfoList;
}

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

- (XTSegmentControl *)segmentControl
{
    if (!_segmentControl) {
        __weak typeof(self) weakSelf = self;
        _segmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kScreen_Width, 70) Items:self.articleInfoList selectedBlock:^(NSInteger index) {
            [weakSelf.carousel scrollToItemAtIndex:index animated:NO];
        }];
        
        _segmentControl.rightButtonBlock = ^(CGRect rightButtomRect) {
            NSLog(@"按钮点击");
        };
        
        [self.view addSubview:_segmentControl];
    }
    
    return _segmentControl;
}

- (iCarousel *)carousel
{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), kScreen_Width, self.view.height - CGRectGetMaxY(self.segmentControl.frame))];
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.decelerationRate = 1.0;
        _carousel.scrollSpeed = 1.0;
        _carousel.type = iCarouselTypeLinear;
        _carousel.pagingEnabled = YES;
        _carousel.clipsToBounds = YES;
        _carousel.bounceDistance = 0.2;
        [self.view addSubview:_carousel];
    }
    
    return _carousel;
}

@end
