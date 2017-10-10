//
//  WWImageView.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/10.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWImageView.h"

@interface WWImageView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

@end

@implementation WWImageView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelH = 50;
    
    self.imageView.frame = self.bounds;
    self.label.frame = CGRectMake(0, self.bounds.size.height - labelH, self.bounds.size.width, labelH);
    [self insertSubview:self.label aboveSubview:self.imageView];
}

- (void)configImageUrl:(NSString *)url title:(NSString *)title
{
    __weak typeof(self) weakSelf = self;
    self.label.text = title;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, str.length)];
    self.label.attributedText = str;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [weakSelf.imageView setImage:image];
        [weakSelf setNeedsLayout];
        [weakSelf layoutIfNeeded];
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        [self addSubview:_label];
    }
    
    return _label;
}

@end
