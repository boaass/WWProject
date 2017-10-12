//
//  MainTableViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "MainViewController.h"
#import "BannerView.h"
#import "XTSegmentControl.h"
#import "iCarousel.h"
#import "WWMainPageAPIManager.h"
#import "WWArticleItemModel.h"
#import "WWMainPageModel.h"
#import "WWMainPageTagModel.h"
#import "WWTagTableView.h"
#import "WWSearchViewController.h"
#import "KOGNetworkingConfiguration.h"

@interface MainViewController () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) WWMainPageAPIManager *manager;
@property (nonatomic, strong) BannerView *bannerView;
@property (nonatomic, strong) XTSegmentControl *segmentControl;
@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *carouselImages;
@property (nonatomic, strong) NSArray <WWMainPageTagModel *> *tags;
@property (nonatomic, strong) NSMutableArray <WWTagTableView *> *validViewPool;
@property (nonatomic, strong) WWSearchViewController *searchVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self ww_setupNavigationBar];
    [self ww_loadData];
}

#pragma mark - private
- (void)ww_setupNavigationBar
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(rightBarButtonAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark - selector
- (void)rightBarButtonAction
{
    NSLog(@"right");
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.searchVC];
    [self presentViewController:navController animated:YES completion:nil];
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
    WWTagTableView *tableView = nil;
    WWMainPageTagModel *model = self.tags[index];
    if (self.validViewPool.count <= index) {
        NSString *url = model.url;
        NSString *method = [url stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""];
        tableView = [[WWTagTableView alloc] initWithFrame:carousel.bounds];
        [tableView loadWithMethodName:method params:nil];
        [self.validViewPool insertObject:tableView atIndex:index];
    } else {
        tableView = [self.validViewPool objectAtIndex:index];
    }
    [tableView setSubScrollsToTop:index == carousel.currentItemIndex];
    return tableView;
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
    [self.view addSubview:view];
    
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
        self.searchVC.accountSearchUrl = model.accountSearchUrl;
        self.searchVC.articleSearchUrl = model.articleSearchUrl;
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
            data.title = model.title;
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

- (NSMutableArray<WWTagTableView *> *)validViewPool
{
    if (!_validViewPool) {
        _validViewPool = [NSMutableArray array];
    }
    return _validViewPool;
}

- (WWSearchViewController *)searchVC
{
    if (!_searchVC) {
        _searchVC = [[WWSearchViewController alloc] init];
    }
    return _searchVC;
}

@end
