//
//  WWAccountTableViewCell.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/13.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WWAccountModel;
@interface WWAccountTableViewCell : UITableViewCell

@property (nonatomic, strong) WWAccountModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

- (CGFloat)cellHeight;

@end
