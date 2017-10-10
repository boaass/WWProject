//
//  WWTagTableView.m
//  WWProject
//
//  Created by zhai chunlin on 17/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWTagTableView.h"
#import "WWArticleInfoManager.h"
#import "WWArticleItemModel.h"
#import "WWMainTableViewCell.h"

@interface WWTagTableView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *methodName;
@property (nonatomic, strong) NSArray <WWArticleItemModel *> *articleInfo;
@property (nonatomic, strong) WWArticleInfoManager *manager;

@end

@implementation WWTagTableView

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.delegate = self;
        self.dataSource = self;
    }
    
    return self;
}

#pragma mark - public
- (void)loadWithMethodName:(NSString *)methodName
{
    self.methodName = methodName;
    
    __weak typeof(self) weakSelf = self;
    [self.manager loadDataWithUrl:self.methodName block:^(WWArticleInfoManager *manager) {
        weakSelf.articleInfo = manager.articleInfo;
        [weakSelf reloadData];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articleInfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WWMainTableViewCell *cell = [WWMainTableViewCell cellWithTableView:tableView];
    WWArticleItemModel *model = self.articleInfo[indexPath.row];
    cell.model = model;
    return cell;
}

#pragma mark - setter & getter
- (WWArticleInfoManager *)manager
{
    if (!_manager) {
        _manager = [[WWArticleInfoManager alloc] init];
    }
    
    return _manager;
}

@end
