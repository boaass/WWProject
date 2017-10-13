//
//  WWAccountTableViewCell.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/13.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountTableViewCell.h"
#import "WWAccountModel.h"

@interface WWAccountTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *wxIDLabel;

@end

@implementation WWAccountTableViewCell
#pragma mark - life circle
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self ww_layout];
}

#pragma mark - public
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"WWAccountTableViewCell";
    WWAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WWAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

- (CGFloat)cellHeight
{
    return self.height;
}

#pragma mark - private
- (void)ww_configData
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconUrl]];
    [self.authorLabel setText:self.model.author];
    [self.wxIDLabel setText:[NSString stringWithFormat:@"微信号: %@", self.model.wxID]];
    
    [self ww_layout];
}

- (void)ww_layout
{
    CGFloat maxW = self.frame.size.width;
    //    CGFloat maxH = self.frame.size.height;
    CGFloat spaceH = 10;
    CGFloat spaceW = 10;
    
    CGFloat iconViewWH = 60;
    CGFloat authorlH = 20;
    CGFloat authorLW = 200;
    CGFloat wxIDLH = 15;
    CGFloat wxIDLW = authorLW;
    
    CGFloat tagLH = authorlH;
    CGFloat tagLW = iconViewWH;
    CGFloat desLW = maxW-spaceW-tagLW;
    
    self.iconImageView.frame = CGRectMake(0, 0, iconViewWH, iconViewWH);
    self.iconImageView.layer.cornerRadius = iconViewWH/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.authorLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+spaceW, 0, authorLW, authorlH);
    self.wxIDLabel.frame = CGRectMake(self.authorLabel.x, CGRectGetMaxY(self.authorLabel.frame), wxIDLW, wxIDLH);
    
    CGFloat desLMaxY = CGRectGetMaxY(self.iconImageView.frame);
    for (int index = 0; index < self.model.descriptions.count; index++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = [UIFont systemFontOfSize:12];
        tagLabel.frame = CGRectMake(0, desLMaxY+spaceH, tagLW, tagLH);
        [self.contentView addSubview:tagLabel];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.numberOfLines = 0;
        UIFont *font = [UIFont systemFontOfSize:12];
        desLabel.font = font;
        NSDictionary *strAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        [self.contentView addSubview:desLabel];
        
        NSDictionary *description = self.model.descriptions[index];
        NSString *tag = [description.allKeys firstObject];
        tagLabel.text = tag;
        NSString *des = [description.allValues firstObject];
        CGFloat desLH = [self ww_heightWithString:des width:desLW attributes:strAttributes];
        desLabel.text = des;
        desLabel.frame = CGRectMake(CGRectGetMaxX(tagLabel.frame), tagLabel.y, desLW, desLH);
        
        desLMaxY = CGRectGetMaxY(desLabel.frame);
    }
    self.height = desLMaxY;
}

- (CGFloat)ww_heightWithString:(NSString *)string width:(CGFloat)width attributes:(NSDictionary *)attributes
{
    CGRect tmpRect = [string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGFloat contentH = tmpRect.size.height;
    return contentH;
}

#pragma mark - setter & getter
- (void)setModel:(WWAccountModel *)model
{
    _model = model;
    [self ww_configData];
}

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] init];
        _authorLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_authorLabel];
    }
    return _authorLabel;
}

- (UILabel *)wxIDLabel
{
    if (!_wxIDLabel) {
        _wxIDLabel = [[UILabel alloc] init];
        _wxIDLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_wxIDLabel];
    }
    return _wxIDLabel;
}

@end
