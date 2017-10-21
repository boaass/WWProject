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
#import "WWArticleItemModel.h"

@interface WWAccountMainPageViewController () <UIWebViewDelegate>

@property (nonatomic, strong) WWArticleItemModel *articleModel;
@property (nonatomic, strong) WWWXArticleAPIManager *manager;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WWAccountMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self ww_setupNavigationBar];
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
    WWPopViewItemButton *checkButton = [WWPopViewItemButton buttonWithImageName:@"" title:@"关注公众号" clickBlock:^{
        NSLog(@"关注公众号");
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
    
    if (![url isEqualToString:self.mainPageUrl]) {
        
        __weak typeof(self) weakSelf = self;
        NSDictionary *requestData = [WWTools combinedParamsForRequestWithSearchUrl:url replaceString:kWWAccountMainPageServiceOnlineApiBaseUrl];
        self.manager.contentUrl = url;
        [self.manager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWWXArticleAPIManager *manager) {
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

#pragma mark - setter & getter
- (void)setMainPageUrl:(NSString *)mainPageUrl
{
    _mainPageUrl = mainPageUrl;
    
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:mainPageUrl]]];
}

- (WWWXArticleAPIManager *)manager
{
    if (!_manager) {
        _manager = [[WWWXArticleAPIManager alloc] init];
        _manager.authorMainUrl = self.mainPageUrl;
    }
    return _manager;
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
