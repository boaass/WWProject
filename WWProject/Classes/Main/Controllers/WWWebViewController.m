//
//  WWWebViewController.m
//  WWProject
//
//  Created by zhai chunlin on 17/10/16.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWWebViewController.h"
#import "WWArticleItemModel.h"

@interface WWWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WWArticleItemModel *model;

@end

@implementation WWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self ww_setupNavBar];
    [self ww_setupWebView];
}

+ (instancetype)webViewControllerWithModel:(WWArticleItemModel *)model
{
    WWWebViewController *webVC = [[WWWebViewController alloc] init];
    webVC.model = model;
    return webVC;
}

- (void)ww_setupNavBar
{
    UIBarButtonItem *leftBBItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction)];
    self.navigationItem.leftBarButtonItem = leftBBItem;
}

- (void)ww_setupWebView
{
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.contentUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"url: %@", request.URL.absoluteString);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

#pragma mark - action
- (void)leftBarButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
