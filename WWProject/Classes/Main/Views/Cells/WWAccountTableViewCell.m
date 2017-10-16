//
//  WWAccountTableViewCell.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/13.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountTableViewCell.h"
#import "WWAccountModel.h"

#define kIconViewWH      70
#define kSpaceW          10
#define kSpaceH          10
#define kAuthorlH        35
#define kAuthorLW        200
#define kWxIDLH          35
#define kFont            12

@interface WWAccountTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *wxIDLabel;
@property (nonatomic, strong) NSMutableArray *tmpLabels;

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
    CGFloat cellHeight = kIconViewWH+kSpaceH;
    CGFloat desLW = self.frame.size.width-kSpaceW-kIconViewWH;
    for (int index = 0; index < self.model.descriptions.count; index++) {
        UIFont *font = [UIFont systemFontOfSize:kFont];
        NSDictionary *description = self.model.descriptions[index];
        NSString *des = [description.allValues firstObject];
        NSDictionary *strAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        CGFloat desLH = [self ww_heightWithString:des width:desLW attributes:strAttributes];
        cellHeight += desLH + kSpaceH;
    }
    
    return cellHeight;
}

#pragma mark - private
- (void)ww_configData
{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconUrl]];
    [self.authorLabel setText:self.model.author];
    [self.wxIDLabel setText:[NSString stringWithFormat:@"微信号: %@", self.model.wxID]];
    
    [self ww_layout];
}

- (void)ww_cleanTmpView
{
    [self.tmpLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tmpLabels removeAllObjects];
}

- (void)ww_layout
{
    [self ww_cleanTmpView];
    
    CGFloat maxW = self.frame.size.width;
    //    CGFloat maxH = self.frame.size.height;
    CGFloat spaceH = kSpaceH;
    CGFloat spaceW = kSpaceW;
    
    CGFloat iconViewWH = kIconViewWH;
    CGFloat authorlH = kAuthorlH;
    CGFloat authorLW = maxW - iconViewWH - spaceW;
    CGFloat wxIDLH = kWxIDLH;
    CGFloat wxIDLW = authorLW;
    
    CGFloat tagLW = iconViewWH;
    CGFloat desLW = authorLW;
    
    self.iconImageView.frame = CGRectMake(0, 0, iconViewWH, iconViewWH);
    self.iconImageView.layer.cornerRadius = iconViewWH/2;
    self.iconImageView.layer.masksToBounds = YES;
    self.authorLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+spaceW, 0, authorLW, authorlH);
    self.wxIDLabel.frame = CGRectMake(self.authorLabel.x, CGRectGetMaxY(self.iconImageView.frame)-wxIDLH, wxIDLW, wxIDLH);
    
    CGFloat desLMaxY = CGRectGetMaxY(self.iconImageView.frame);
    for (int index = 0; index < self.model.descriptions.count; index++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.font = [UIFont systemFontOfSize:kFont];
        [self.contentView addSubview:tagLabel];
        [self.tmpLabels addObject:tagLabel];
        
        UILabel *desLabel = [[UILabel alloc] init];
        desLabel.numberOfLines = 0;
        UIFont *font = [UIFont systemFontOfSize:kFont];
        desLabel.font = font;
        NSDictionary *strAttributes = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        [self.contentView addSubview:desLabel];
        [self.tmpLabels addObject:desLabel];
        
        NSDictionary *description = self.model.descriptions[index];
        NSString *tag = [description.allKeys firstObject];
        CGFloat tagLH = [self ww_heightWithString:tag width:tagLW attributes:strAttributes];
        tagLabel.text = tag;
        tagLabel.frame = CGRectMake(0, desLMaxY+spaceH, tagLW, tagLH);
        
        NSString *des = [description.allValues firstObject];
        CGFloat desLH = [self ww_heightWithString:des width:desLW attributes:strAttributes];
        desLabel.text = des;
        desLabel.frame = CGRectMake(self.authorLabel.x, tagLabel.y, desLW, desLH);
        desLMaxY = CGRectGetMaxY(desLabel.frame);
        
        NSLog(@"tag y:%f, desLabel y:%f", tagLabel.y, desLabel.y);
    }
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
        _authorLabel.font = [UIFont systemFontOfSize:kFont];
        [self.contentView addSubview:_authorLabel];
    }
    return _authorLabel;
}

- (UILabel *)wxIDLabel
{
    if (!_wxIDLabel) {
        _wxIDLabel = [[UILabel alloc] init];
        _wxIDLabel.font = [UIFont systemFontOfSize:kFont-2];
        [self.contentView addSubview:_wxIDLabel];
    }
    return _wxIDLabel;
}

- (NSMutableArray *)tmpLabels
{
    if (!_tmpLabels) {
        _tmpLabels = [NSMutableArray array];
    }
    return _tmpLabels;
}

@end
