//
//  WWWebPopView.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/17.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWWebPopView.h"
#import "WWPopViewItemButton.h"

#define SCREEN_WIDTH        [UIScreen mainScreen].bounds.size.width
#define SCREEN_Height       [UIScreen mainScreen].bounds.size.height
#define kPopViewColor        [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]

@interface WWWebPopView ()

@property (nonatomic, strong) UIButton *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, assign) BOOL isShowing;

@end

@implementation WWWebPopView
#pragma mark - life circle
- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        self.isShowing = NO;
        [self ww_setupUI];
    }
    return self;
}

#pragma mark - public
+ (instancetype)webPopView
{
    WWWebPopView *webPopView = [[WWWebPopView alloc] init];
    return webPopView;
}

- (void)show
{
    if (self.isShowing) {
        return;
    }
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.7 animations:^{
        weakSelf.backgroundView.hidden = NO;
        weakSelf.scrollView.y = weakSelf.height - weakSelf.scrollView.height - weakSelf.cancelButton.height;
        weakSelf.cancelButton.y = CGRectGetMaxY(weakSelf.scrollView.frame);
    } completion:^(BOOL finished) {
        weakSelf.isShowing = YES;
    }];
}

- (void)dissmiss
{
    if (!self.isShowing) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.7 animations:^{
        weakSelf.backgroundView.hidden = YES;
        weakSelf.scrollView.y = weakSelf.height;
        weakSelf.cancelButton.y = CGRectGetMaxY(weakSelf.scrollView.frame);
    } completion:^(BOOL finished) {
        weakSelf.isShowing = NO;
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - private
- (void)ww_setupUI
{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    
    CGFloat checkButtonW = 60;
    CGFloat checkButtonH = 80;
    CGFloat scrollViewW = self.width;
    CGFloat scrollViewH = 120;
    CGFloat spaceH = 10;
    WWPopViewItemButton *checkButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"查看公众号" clickBlock:^{
        NSLog(@"查看公众号");
    }];
    checkButton.frame = CGRectMake(spaceH, spaceH, checkButtonW, checkButtonH);
    [self.scrollView addSubview:checkButton];
    
    WWPopViewItemButton *favoriteButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"收藏" clickBlock:^{
        NSLog(@"收藏");
    }];
    favoriteButton.frame = CGRectMake(CGRectGetMaxX(checkButton.frame)+spaceH, spaceH, checkButtonW, checkButtonH);
    self.scrollView.frame = CGRectMake(0, self.height, scrollViewW, scrollViewH);
    [self.scrollView addSubview:favoriteButton];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetMaxX(favoriteButton.frame)+spaceH, 0)];
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), self.width, checkButtonW);
}

#pragma mark - action
- (void)backgroundViewClick
{
    [self dissmiss];
}

#pragma mark - setter & getter
- (UIButton *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundView.alpha = 0.3;
        _backgroundView.backgroundColor = [UIColor blackColor];
        [_backgroundView addTarget:self action:@selector(backgroundViewClick) forControlEvents:UIControlEventTouchUpInside];
        _backgroundView.hidden = YES;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        self.scrollView.backgroundColor = kPopViewColor;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setBackgroundColor:[UIColor whiteColor]];
//        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"取消"];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 2)];
        [_cancelButton setAttributedTitle:attString forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dissmiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}

@end
