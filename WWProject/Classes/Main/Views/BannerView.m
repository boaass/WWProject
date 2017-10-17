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
#import "WWArticleItemModel.h"

@interface BannerView ()

@property (nonatomic, strong) NSMutableArray <WWImageView *> * reuseViews;
@property (nonatomic, strong) AutoSlideScrollView *autoSlideSV;

@end

@implementation BannerView

#pragma mark - public
- (void)setArticleModelList:(NSArray<WWArticleItemModel *> *)articleModelList
{
    _articleModelList = articleModelList;
    
    [self reload];
}

- (void)reload
{
    self.hidden = self.articleModelList.count <= 0;
    if (self.articleModelList.count <= 0) {
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
            return weakSelf.articleModelList.count;
        };
        
        _autoSlideSV.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
            if (weakSelf.articleModelList.count > pageIndex) {
                WWImageView *imageView = [weakSelf ww_reuseViewForIndex:pageIndex];
                WWArticleItemModel *model = weakSelf.articleModelList[pageIndex];
                [imageView configImageUrl:model.bigImageUrl title:model.title];
                return imageView;
            } else {
                return [[UIView alloc] init];
            }
        };
        
        _autoSlideSV.tapActionBlock = ^(NSInteger pageIndex) {
            if (weakSelf.tapBlock && weakSelf.articleModelList.count > pageIndex) {
                weakSelf.tapBlock(weakSelf.articleModelList[pageIndex]);
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
