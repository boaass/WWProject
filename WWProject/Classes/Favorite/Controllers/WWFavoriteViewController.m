//
//  WWFavoriteViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/25.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWFavoriteViewController.h"
#import "iCarousel.h"
#import "XTSegmentControl.h"
#import "WWFavoriteTableView.h"

@interface WWFavoriteViewController () <iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) XTSegmentControl *segmentControl;
@property (nonatomic, strong) WWFavoriteTableView *tableView;

@end

@implementation WWFavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self ww_refreshData];
}

#pragma mark - private
- (void)ww_refreshData
{
    [self.carousel reloadData];
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
    self.tableView = (WWFavoriteTableView *)carousel.currentItemView;
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
    return 2;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    WWFavoriteTableView *tableView = [WWFavoriteTableView tableViewWithType:index];
    tableView.frame = carousel.frame;
    tableView.superVC = self;
    [tableView setSubScrollsToTop:index == carousel.currentItemIndex];
    return tableView;
}

#pragma mark - setter & getter
- (XTSegmentControl *)segmentControl
{
    if (!_segmentControl) {
        __weak typeof(self) weakSelf = self;
        _segmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 50) Items:@[@"文章", @"公众号"] segmentControlItemCount:2 selectedBlock:^(NSInteger index) {
            [weakSelf.carousel scrollToItemAtIndex:index animated:YES];
        }];
        _segmentControl.segmentControlItemCount = 2;
        
        [self.view addSubview:_segmentControl];
    }
    return _segmentControl;
}

- (iCarousel *)carousel
{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentControl.frame), kScreen_Width, self.view.height-CGRectGetMaxY(self.segmentControl.frame))];
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
