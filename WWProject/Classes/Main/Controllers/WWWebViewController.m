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
#import "WWWXArticleAPIManager.h"
#import "WWAccountMainPageAPIManager.h"
#import "WWAccountSearchAPIManager.h"
#import "WWPopViewItemButton.h"
#import "KOGNetworkingConfiguration.h"
#import "WWMainPageModel.h"
#import "WWArticleCacheModel.h"
#import "WWAccountMainPageViewController.h"

@interface WWWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong, readwrite) WWArticleItemModel *articleModel;
@property (nonatomic, strong) WWAccountModel *accountModel;
@property (nonatomic, strong) WWArticleSearchAPIManager *articleManager;
@property (nonatomic, strong) WWWXArticleAPIManager *wxArticleManager;
@property (nonatomic, strong) WWAccountMainPageAPIManager *accountManager;
@property (nonatomic, strong) WWAccountSearchAPIManager *accountSearchManager;

@end

@implementation WWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ww_setupNavBar];
    [self ww_setupWebView];
}

+ (instancetype)webViewControllerWithArticleModel:(WWArticleItemModel *)model
{
    WWWebViewController *webVC = [[WWWebViewController alloc] init];
    webVC.articleModel = model;
    webVC.isOpened = NO;
    return webVC;
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    BOOL hasCache = [WWTools hasCacheFavoriteArticle:self.articleModel];
    __weak typeof(self) weakSelf = self;
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:hasCache?@"取消收藏":@"收藏" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        NSLog(@"收藏");
        if (hasCache) {
            [WWTools removeFavoriteArticle:weakSelf.articleModel];
        } else {
            WWArticleCacheModel *cacheModel = [[WWArticleCacheModel alloc] init];
            cacheModel.cacheTimeStamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            cacheModel.articleModel = weakSelf.articleModel;
            [WWTools archiveFavoriteArticle:cacheModel];
        }
        if (weakSelf.touchBlock) {
            weakSelf.touchBlock();
        }
    }];
    NSArray *items = @[action];
    return items;
}

#pragma mark - private
- (void)ww_setupNavBar
{
    self.title = self.articleModel.author;
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
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.articleModel.contentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
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
    WWPopViewItemButton *checkButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"查看公众号" clickBlock:^{
        NSLog(@"查看公众号");
        if (!self.isOpened) {
            // 跳转公众号主页
            WWAccountMainPageViewController *vc = [WWAccountMainPageViewController accountMainPageWithAccountModel:weakSelf.accountModel];
            vc.title = weakSelf.articleModel.author;
            WWMainNavigationController *nav = [[WWMainNavigationController alloc] initWithRootViewController:vc];
            [weakSelf.navigationController presentViewController:nav animated:YES completion:nil];
        } else {
            [weakSelf closeBarButtonAction];
        }
        
    }];
    
    BOOL hasCache = [WWTools hasCacheFavoriteArticle:self.articleModel];
    WWPopViewItemButton *favoriteButton = [WWPopViewItemButton buttonWithImageName:@"" title:hasCache?@"取消收藏":@"收藏文章" clickBlock:^{
        NSLog(@"收藏文章");
        if (hasCache) {
            [WWTools removeFavoriteArticle:weakSelf.articleModel];
        } else {
            WWArticleCacheModel *cacheModel = [[WWArticleCacheModel alloc] init];
            cacheModel.articleModel = weakSelf.articleModel;
            cacheModel.cacheTimeStamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            [WWTools archiveFavoriteArticle:cacheModel];
        }
    }];
    NSArray *buttonList = @[checkButton, favoriteButton];
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

- (WWWXArticleAPIManager *)wxArticleManager
{
    if (!_wxArticleManager) {
        _wxArticleManager = [[WWWXArticleAPIManager alloc] init];
    }
    return _wxArticleManager;
}

- (WWAccountMainPageAPIManager *)accountManager
{
    if (!_accountManager) {
        _accountManager = [[WWAccountMainPageAPIManager alloc] init];
        _accountManager.authorMainPageUrl = self.articleModel.authorMainUrl;
    }
    return _accountManager;
}

- (WWAccountSearchAPIManager *)accountSearchManager
{
    if (!_accountSearchManager) {
        _accountSearchManager = [[WWAccountSearchAPIManager alloc] init];
    }
    return _accountSearchManager;
}

- (void)setArticleModel:(WWArticleItemModel *)articleModel
{
    _articleModel = articleModel;
    __weak typeof(self) weakSelf = self;
    if (!articleModel.authorMainUrl || articleModel.authorMainUrl.length==0) {
        // 点击轮播图跳转到该页面
        NSDictionary *requestData = [WWTools combinedParamsForRequestWithSearchUrl:articleModel.contentUrl replaceString:kWWWXServiceOnlineApiBaseUrl];
        self.wxArticleManager.contentUrl = articleModel.contentUrl;
        [self.wxArticleManager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWWXArticleAPIManager *manager) {
            if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                NSString *searchUrl = [[[WWMainPageModel sharedInstance].accountSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""] stringByAppendingString:manager.articleInfo.wxID];
                NSDictionary *requestParam = [WWTools combinedParamsForRequestWithSearchUrl:searchUrl replaceString:kWWMainPageServiceOnlineApiBaseUrl];
                [weakSelf.accountSearchManager loadDataWithUrl:[[requestParam allKeys] firstObject] params:[[requestParam allValues] firstObject] block:^(WWAccountSearchAPIManager *manager) {
                    weakSelf.accountModel = [manager.accountInfos firstObject];
                }];
            }
        }];
    } else {
        NSDictionary *requestData = [WWTools combinedParamsForRequestWithSearchUrl:articleModel.authorMainUrl replaceString:kWWWXServiceOnlineApiBaseUrl];
        [self.accountManager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWAccountMainPageAPIManager *manager) {
            if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                weakSelf.accountModel = manager.accountInfo;
            }
        }];
    }
}

@end
