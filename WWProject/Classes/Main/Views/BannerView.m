//
//  BannerView.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "BannerView.h"
#import "AutoSlideScrollView.h"

@interface BannerView ()

@property (nonatomic, strong) NSMutableArray <UIImageView *> * reuseViews;
@property (nonatomic, strong) AutoSlideScrollView *autoSlideSV;

@end

@implementation BannerView

#pragma mark - public
- (void)configBannerList:(NSArray <BannerData *> *)bannerList
{
    self.bannerList = bannerList;
    
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
- (UIImageView *)ww_reuseViewForIndex:(NSInteger)pageIndex
{
    UIImageView *imageView;
    NSInteger currentPageIndex = self.autoSlideSV.currentPageIndex;
    if (pageIndex == currentPageIndex) {
        imageView = self.reuseViews[1];
    }else if (pageIndex == currentPageIndex + 1
              || (labs(pageIndex - currentPageIndex) > 1 && pageIndex < currentPageIndex)){
        imageView = self.reuseViews[2];
    }else{
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
                UIImageView *imageView = [weakSelf ww_reuseViewForIndex:pageIndex];
                BannerData *bannerData = weakSelf.bannerList[pageIndex];
                [imageView sd_setImageWithURL:[NSURL URLWithString:bannerData.imageUrl]];
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

- (NSMutableArray<UIImageView *> *)reuseViews
{
    if (!_reuseViews) {
        _reuseViews = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 3; i++) {
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width,self.height)];
            view.backgroundColor = [UIColor colorWithHexString:@"0xe5e5e5"];
            view.clipsToBounds = YES;
            view.contentMode = UIViewContentModeScaleAspectFill;
            [_reuseViews addObject:view];
        }
    }
    
    return _reuseViews;
}

@end
