//
//  WWFavoriteTableView.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/25.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WWFavoriteArticleType,
    WWFavoriteAccountType
} WWFavoriteType;

@interface WWFavoriteTableView : UITableView

@property (nonatomic, strong) UIViewController *superVC;
@property (nonatomic, strong, readonly) NSArray *cellDatas;
@property (nonatomic, assign, readonly) WWFavoriteType currentFavoriteType;

+ (instancetype)tableViewWithType:(WWFavoriteType)favoriteType;

@end
