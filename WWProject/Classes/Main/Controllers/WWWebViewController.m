//
//  WWWebViewController.m
//  WWProject
//
//  Created by zhai chunlin on 17/10/16.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWWebViewController.h"
#import "WWArticleItemModel.h"
#import "WWAccountModel.h"
#import "WWWebPopView.h"
#import "WWArticleSearchAPIManager.h"
#import "WWAccountSearchAPIManager.h"
#import "WWPopViewItemButton.h"

@interface WWWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WWArticleItemModel *model;
@property (nonatomic, strong) WWArticleSearchAPIManager *articleManager;
@property (nonatomic, strong) WWAccountSearchAPIManager *accountManager;
@property (nonatomic, assign) WWWebViewControllerType type;
@property (nonatomic, strong) NSString *viewTitle;
@property (nonatomic, strong) NSString *requestUrl;

@end

@implementation WWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ww_setupNavBar];
    [self ww_setupWebView];
}

+ (instancetype)webViewControllerWithType:(WWWebViewControllerType)type
{
    WWWebViewController *webVC = [[WWWebViewController alloc] init];
    webVC.type = type;
    return webVC;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:@"关注" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"关注");
    }];
    NSArray *items = @[action];
    return items;
}

#pragma mark - private
- (void)ww_setupNavBar
{
    self.title = self.viewTitle;
    if ([self.webView canGoBack]) {
        UIBarButtonItem *leftBBItem1 = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBarButtonAction)];
        UIBarButtonItem *leftBBItem2 = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButtonAction)];
        
        self.navigationItem.leftBarButtonItems = @[leftBBItem1, leftBBItem2];
    } else {
        self.navigationItem.leftBarButtonItems = nil;
        UIBarButtonItem *leftBBItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeBarButtonAction)];
        self.navigationItem.leftBarButtonItem = leftBBItem;
        
        UIBarButtonItem *rightBBItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tabbar_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction)];
        self.navigationItem.rightBarButtonItem = rightBBItem;
    }
}

- (void)ww_setupWebView
{
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.requestUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url: %@", url);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self ww_setupNavBar];
}

#pragma mark - action
- (void)returnBarButtonAction
{
    [self.webView goBack];
}

- (void)closeBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonAction
{
    __weak typeof(self) weakSelf = self;
    NSArray *buttonList = nil;
    switch (self.type) {
        case WWWebViewControllerTypeAccount:
        {
            WWPopViewItemButton *focusButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"关注公众号" clickBlock:^{
                NSLog(@"关注公众号");
            }];
            buttonList = @[focusButton];
        }
            break;
        case WWWebViewControllerTypeArticle:
        {
            WWPopViewItemButton *checkButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"查看公众号" clickBlock:^{
                NSLog(@"查看公众号");
                
                [weakSelf.accountManager loadDataWithUrl:<#(NSString *)#> params:<#(NSDictionary *)#> block:<#^(WWAccountSearchAPIManager *)block#>]
                weakSelf.type = WWWebViewControllerTypeAccount;
                weakSelf.accountModel =
            }];
            
            WWPopViewItemButton *favoriteButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"收藏文章" clickBlock:^{
                NSLog(@"收藏文章");
            }];
            buttonList = @[checkButton, favoriteButton];
        }
            break;
    }
    WWWebPopView *popView = [WWWebPopView webPopViewWithButtonList:buttonList];
    [popView show];
}

#pragma mark - setter & getter
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = self.view.frame;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (WWArticleSearchAPIManager *)articleManager
{
    if (!_articleManager) {
        _articleManager = [[WWArticleSearchAPIManager alloc] init];
    }
    return _articleManager;
}

- (WWAccountSearchAPIManager *)accountManager
{
    if (!_accountManager) {
        _accountManager = [[WWAccountSearchAPIManager alloc] init];
    }
    return _accountManager;
}

- (NSString *)viewTitle
{
    switch (self.type) {
        case WWWebViewControllerTypeArticle:
        {
            self.viewTitle = self.articleModel.author;
        }
            break;
        case WWWebViewControllerTypeAccount:
        {
            self.viewTitle = self.accountModel.author;
        }
            break;
    }
    return _viewTitle;
}

- (NSString *)requestUrl
{
    switch (self.type) {
        case WWWebViewControllerTypeArticle:
        {
            _requestUrl = self.articleModel.contentUrl;
        }
            break;
        case WWWebViewControllerTypeAccount:
        {
            _requestUrl = self.accountModel.authorMainUrl;
        }
            break;
    }
    return _requestUrl;
}

@end
