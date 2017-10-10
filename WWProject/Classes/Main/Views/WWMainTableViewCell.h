//
//  WWMainTableViewCell.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/10.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWArticleItemModel;
@interface WWMainTableViewCell : UITableViewCell

@property (nonatomic, strong) WWArticleItemModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
