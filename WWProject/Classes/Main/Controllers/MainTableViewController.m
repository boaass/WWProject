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
#import "WWMainPageAPIManager.h"
#import "WWArticleItemModel.h"
#import "WWMainPageModel.h"
#import "WWMainPageTagModel.h"

@interface MainTableViewController () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) WWMainPageAPIManager *manager;
@property (nonatomic, strong) BannerView *bannerView;
@property (nonatomic, strong) XTSegmentControl *segmentControl;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *carouselImages;
@property (nonatomic, strong) NSArray <WWMainPageTagModel *> *tags;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ww_loadData];
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
    return self.tags.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    UILabel *label = (UILabel *)view;
    WWMainPageTagModel *model = self.tags[index];
    if (label) {
        label.text = model.url;
    } else {
        label = [[UILabel alloc] initWithFrame:carousel.bounds];
        label.text = model.url;
    }
    
    [label setSubScrollsToTop:index == carousel.currentItemIndex];
    return label;
}

#pragma mark - private
- (void)ww_refreshBannerView
{
    [self.bannerView reload];
}

- (void)ww_setupHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.bannerView.height+self.segmentControl.height)];
    [view addSubview:self.bannerView];
    [view addSubview:self.segmentControl];
    self.tableView.tableHeaderView = view;
    
    [self.carousel reloadData];
}

- (void)ww_loadData
{
    __weak typeof(self) weakSelf = self;
    [self.manager loadDataWithBlock:^(WWMainPageAPIManager *manager) {
        if (manager.errorType != KOGAPIManagerErrorTypeSuccess) {
            NSLog(@"%@", manager.error);
            return ;
        }
        
        WWMainPageModel *model = manager.model;
        weakSelf.carouselImages = model.carouselImages;
        weakSelf.tags = model.tags;
        [weakSelf ww_setupHeaderView];
    }];
}
#pragma mark - setter & getter
- (WWMainPageAPIManager *)manager
{
    if (!_manager) {
        _manager = [[WWMainPageAPIManager alloc] init];
    }
    
    return _manager;
}

- (BannerView *)bannerView
{
    if (!_bannerView) {
        _bannerView = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Width * 214/640)];
        NSMutableArray *bannerList = [NSMutableArray array];
        for (WWArticleItemModel *model in self.carouselImages) {
            BannerData *data = [[BannerData alloc] init];
            data.imageUrl = model.bigImageUrl;
            [bannerList addObject:data];
        }
        _bannerView.bannerList = [bannerList copy];
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
        NSMutableArray *tagNames = [NSMutableArray array];
        for (WWMainPageTagModel *model in self.tags) {
            [tagNames addObject:model.tagName];
        }
        _segmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kScreen_Width, 70) Items:[tagNames copy] selectedBlock:^(NSInteger index) {
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
