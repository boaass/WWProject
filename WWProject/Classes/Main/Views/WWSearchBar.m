//
//  WWSearchBar.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWSearchBar.h"

@interface WWSearchBar () <UITextFieldDelegate>

@property (nonatomic, strong) SearchBarEndEditBlcok block;
@property (nonatomic, strong, readwrite) NSString *searchContent;
@property (nonatomic, assign, readwrite) WWSearchType searchType;
@property (nonatomic, strong) NSArray *searchTypeDescriptions;

@end

@implementation WWSearchBar

+ (instancetype)searchBarWithBlock:(SearchBarEndEditBlcok)block
{
    WWSearchBar *searchBar =[[WWSearchBar alloc] init];
    searchBar.block = block;
    return searchBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.size = CGSizeMake(300, 30);
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"搜索";
        self.borderStyle = UITextBorderStyleRoundedRect;
        self.delegate = self;
        
        UIButton *leftButton = [[UIButton alloc] init];
        leftButton.frame = CGRectMake(0, 0, 70, 30);
        [leftButton setTitle:self.searchTypeDescriptions[self.searchType] forState:UIControlStateNormal];
        leftButton.layer.cornerRadius = leftButton.height/4;
        leftButton.backgroundColor = [UIColor blueColor];
        [leftButton addTarget:self action:@selector(swichSearchType) forControlEvents:UIControlEventTouchUpInside];
        self.leftView = leftButton;
        self.leftViewMode = UITextFieldViewModeAlways;
    }
    return self;
}

#pragma mark - selector
- (void)swichSearchType
{
    self.searchType = self.searchType ? WWAccountSearchType : WWArticleSearchType;
}

#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.searchContent = textField.text;
    if (self.block) {
        self.block(self);
    }
    return YES;
}

#pragma mark - setter & getter
- (void)setSearchType:(WWSearchType)searchType
{
    if (_searchType == searchType) {
        return;
    }
    _searchType = searchType;
    
    UIButton *button = (UIButton *)self.leftView;
    [button setTitle:self.searchTypeDescriptions[searchType] forState:UIControlStateNormal];
}

- (NSArray *)searchTypeDescriptions
{
    if (!_searchTypeDescriptions) {
        _searchTypeDescriptions = [NSArray arrayWithObjects:@"公众号", @"文章", nil];
    }
    return _searchTypeDescriptions;
}

@end
