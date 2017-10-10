//
//  BannerView.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "BannerView.h"
#import "AutoSlideScrollView.h"
#import "WWImageView.h"

@implementation BannerData
@end

@interface BannerView ()

@property (nonatomic, strong) NSMutableArray <WWImageView *> * reuseViews;
@property (nonatomic, strong) AutoSlideScrollView *autoSlideSV;

@end

@implementation BannerView

#pragma mark - public
- (void)setBannerList:(NSArray<BannerData *> *)bannerList
{
    _bannerList = bannerList;
    
    [self reload];
}

- (void)reload
{
    self.hidden = self.bannerList.count <= 0;
    if (self.bannerList.count <= 0) {
        return;
    }
    
    [self.autoSlideSV reloadData];
}

#pragma mark - private
- (WWImageView *)ww_reuseViewForIndex:(NSInteger)pageIndex
{
    WWImageView *imageView;
    NSInteger currentPageIndex = self.autoSlideSV.currentPageIndex;
    if (pageIndex == currentPageIndex) {
        imageView = self.reuseViews[1];
    } else if (pageIndex == currentPageIndex + 1
              || (labs(pageIndex - currentPageIndex) > 1 && pageIndex < currentPageIndex)){
        imageView = self.reuseViews[2];
    } else{
        imageView = self.reuseViews[0];
    }
    return imageView;
}

#pragma mark - getter & setter
- (AutoSlideScrollView *)autoSlideSV
{
    if (!_autoSlideSV) {
        __weak typeof(self) weakSelf = self;
        _autoSlideSV = [[AutoSlideScrollView alloc] initWithFrame:self.frame animationDuration:5.0];
        _autoSlideSV.layer.masksToBounds = YES;
        _autoSlideSV.scrollView.scrollsToTop = NO;
        
        _autoSlideSV.totalPagesCount = ^NSInteger{
            return weakSelf.bannerList.count;
        };
        
        _autoSlideSV.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
            if (weakSelf.bannerList.count > pageIndex) {
                WWImageView *imageView = [weakSelf ww_reuseViewForIndex:pageIndex];
                BannerData *bannerData = weakSelf.bannerList[pageIndex];
                [imageView configImageUrl:bannerData.imageUrl title:bannerData.title];
                return imageView;
            } else {
                return [[UIView alloc] init];
            }
        };
        
        _autoSlideSV.tapActionBlock = ^(NSInteger pageIndex) {
            if (weakSelf.tapBlock && weakSelf.bannerList.count > pageIndex) {
                weakSelf.tapBlock(weakSelf.bannerList[pageIndex]);
            }
        };
        
        [self addSubview:_autoSlideSV];
    }
    
    return _autoSlideSV;
}

- (NSMutableArray<WWImageView *> *)reuseViews
{
    if (!_reuseViews) {
        _reuseViews = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            WWImageView *view = [[WWImageView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.height)];
            view.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
            view.clipsToBounds = YES;
            view.contentMode = UIViewContentModeScaleToFill;
            [_reuseViews addObject:view];
        }
    }
    
    return _reuseViews;
}

@end
