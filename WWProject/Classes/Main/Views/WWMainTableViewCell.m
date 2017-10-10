//
//  WWMainTableViewCell.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/10.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWMainTableViewCell.h"
#import "WWArticleItemModel.h"

@interface WWMainTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *overwriteLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *bigImageView;

@end

@implementation WWMainTableViewCell

#pragma mark - life circle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat maxW = self.frame.size.width;
    CGFloat maxH = self.frame.size.height;
    
    CGFloat spaceH = 10;
    CGFloat spaceW = 10;
    CGFloat imageViewWH = maxH - 2*spaceH;
    CGFloat titleH = 20;
    CGFloat titleW = maxW - 3*spaceW - imageViewWH;
    CGFloat overwriteW = titleW;
    CGFloat overwriteH = 40;
    CGFloat authorW = 50;
    CGFloat authorH = 10;
    CGFloat timeW = 50;
    CGFloat timeH = authorH;
    
    self.titleLabel.frame = CGRectMake(0, spaceH, titleW, titleH);
    self.overwriteLabel.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+spaceH, overwriteW, overwriteH);
    self.authorLabel.frame = CGRectMake(0, CGRectGetMaxY(self.overwriteLabel.frame)+spaceH, authorW, authorH);
    self.timeLabel.frame = CGRectMake(CGRectGetMaxX(self.authorLabel.frame)+spaceW, self.authorLabel.frame.origin.y, timeW, timeH);
    self.bigImageView.frame = CGRectMake(maxW-spaceW-imageViewWH, spaceH, imageViewWH, imageViewWH);
}

#pragma mark - public
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"WWMainTableViewCell";
    WWMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WWMainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

#pragma mark - private
- (void)ww_configData
{
    self.titleLabel.text = self.model.title;
    self.overwriteLabel.text = self.model.overview;
    self.authorLabel.text = self.model.author;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.model.timeStamp integerValue]];
    NSString *timeStr = [format stringFromDate:date];
    self.timeLabel.text = timeStr;
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:self.model.bigImageUrl]];
}

#pragma mark - setter & getter
- (void)setModel:(WWArticleItemModel *)model
{
    _model = model;
    [self ww_configData];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)overwriteLabel
{
    if (!_overwriteLabel) {
        _overwriteLabel = [[UILabel alloc] init];
        _overwriteLabel.numberOfLines = 2;
        _overwriteLabel.font = [UIFont systemFontOfSize:8];
        [self.contentView addSubview:_overwriteLabel];
    }
    return _overwriteLabel;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:5];
        [self.contentView addSubview:_authorLabel];
    }
    return _authorLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:5];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)bigImageView
{
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_bigImageView];
    }
    return _bigImageView;
}

@end
