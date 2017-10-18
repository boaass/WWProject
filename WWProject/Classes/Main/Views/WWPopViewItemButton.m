//
//  WWPopViewItemButton.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/17.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWPopViewItemButton.h"

@interface WWPopViewItemButton ()

@property (nonatomic, strong) ButtonClickBlock clickBlock;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WWPopViewItemButton

+ (instancetype)buttonWithImageName:(NSString *)imageName title:(NSString *)title clickBlock:(ButtonClickBlock)clickBlock
{
    WWPopViewItemButton *view = [[WWPopViewItemButton alloc] init];
    [view.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    view.titleLabel.text = title;
    view.clickBlock = clickBlock;
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxW = self.frame.size.width;
    CGFloat maxH = self.frame.size.height;
    CGFloat buttonWH = maxW;
    CGFloat titleLW = buttonWH;
    CGFloat titleLH = maxH - buttonWH;
    
    self.button.frame = CGRectMake(0, 0, buttonWH, buttonWH);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.button.frame), titleLW, titleLH);
}

#pragma mark - selector
- (void)buttonClick
{
    if ([self.superview.superview respondsToSelector:@selector(dismiss)]) {
        [self.superview.superview performSelector:@selector(dismiss)];
    }
    if (self.clickBlock) {
        self.clickBlock();
    }
}

#pragma mark - setter & getter
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_button];
        [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [_button setBackgroundColor:[UIColor whiteColor]];
        _button.layer.cornerRadius = 15;
    }
    return _button;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:11];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
