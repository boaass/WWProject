//
//  WWAccountMainPageViewController.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountMainPageViewController.h"
#import "KOGNetworkingConfiguration.h"
#import "WWPopViewItemButton.h"
#import "WWWebPopView.h"
#import "WWWebViewController.h"
#import "WWWXArticleAPIManager.h"
#import "WWAccountMainPageAPIManager.h"
#import "WWArticleItemModel.h"
#import "WWAccountModel.h"

@interface WWAccountMainPageViewController () <UIWebViewDelegate>

@property (nonatomic, strong) WWArticleItemModel *articleModel;
@property (nonatomic, strong, readwrite) WWAccountModel *accounteModel;
@property (nonatomic, strong) WWWXArticleAPIManager *articleManager;
@property (nonatomic, strong) WWAccountMainPageAPIManager *accountManager;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WWAccountMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ww_setupNavigationBar];
    [self ww_loadWebView];
}

- (NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
    BOOL hasCache = [WWTools hasCacheFavoriteAccount:self.accounteModel];
    __weak typeof(self) weakSelf = self;
    UIPreviewAction *action = [UIPreviewAction actionWithTitle:hasCache?@"取消关注":@"关注公众号" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
        if (hasCache) {
            [WWTools removeFavoriteAccount:weakSelf.accounteModel];
        } else {
            [WWTools archiveFavoriteAccount:weakSelf.accounteModel];
        }
    }];
    NSArray *items = @[action];
    return items;
}

+ (instancetype)accountMainPageWithAccountModel:(WWAccountModel *)accounteModel
{
    WWAccountMainPageViewController *vc = [[WWAccountMainPageViewController alloc] init];
    vc.accounteModel = accounteModel;
    return vc;
}

#pragma mark - private
- (void)ww_setupNavigationBar
{
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

- (void)ww_loadWebView
{
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.accounteModel.authorMainUrl]]];
}

- (void)ww_pushVCWithModel:(WWArticleItemModel *)model
{
    WWWebViewController *webVC = [WWWebViewController webViewControllerWithArticleModel:model];
    webVC.isOpened = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - selector
- (void)closeBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBarButtonAction
{
    BOOL hasCache = [WWTools hasCacheFavoriteAccount:self.accounteModel];
    __weak typeof(self) weakSelf = self;
    WWPopViewItemButton *checkButton = [WWPopViewItemButton buttonWithImageName:@"" title:hasCache?@"取消关注":@"关注公众号" clickBlock:^{
        if (hasCache) {
            [WWTools removeFavoriteAccount:weakSelf.accounteModel];
        } else {
            [WWTools archiveFavoriteAccount:weakSelf.accounteModel];
        }
    }];
    
    NSArray *buttonList = @[checkButton];
    WWWebPopView *popView = [WWWebPopView webPopViewWithButtonList:buttonList];
    [popView show];
}


- (void)returnBarButtonAction
{
    [self.webView goBack];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
    NSLog(@"url: %@", url);
    if (!url || url.length == 0) {
        return NO;
    }
    __weak typeof(self) weakSelf = self;
    if (![url isEqualToString:self.accounteModel.authorMainUrl]) {
        NSDictionary *requestData = [WWTools combinedParamsForRequestWithSearchUrl:url replaceString:kWWWXServiceOnlineApiBaseUrl];
        self.articleManager.contentUrl = url;
        [self.articleManager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWWXArticleAPIManager *manager) {
            if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
                weakSelf.articleModel = manager.articleInfo;
                [weakSelf ww_pushVCWithModel:manager.articleInfo];
            }
        }];

        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self ww_setupNavigationBar];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"error: %@", error);
}

#pragma mark - setter & getter
- (WWWXArticleAPIManager *)articleManager
{
    if (!_articleManager) {
        _articleManager = [[WWWXArticleAPIManager alloc] init];
        _articleManager.authorMainUrl = self.accounteModel.authorMainUrl;
    }
    return _articleManager;
}

- (WWAccountMainPageAPIManager *)accountManager
{
    if (!_accountManager) {
        _accountManager = [[WWAccountMainPageAPIManager alloc] init];
        _accountManager.authorMainPageUrl = self.accounteModel.authorMainUrl;
    }
    return _accountManager;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.frame = self.view.bounds;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

@end
