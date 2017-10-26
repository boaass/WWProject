//
//  WWWXArticleAPIManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWWXArticleAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWArticleItemModel.h"
#import "WWMainPageModel.h"

@interface WWWXArticleAPIManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) WWArticleItemModel *articleInfo;
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, strong) WXArticleInfoCompleteBlock block;

@end

@implementation WWWXArticleAPIManager

#pragma mark - life circle
- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.paramSource = self;
    }
    
    return self;
}

#pragma mark - public
- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(WXArticleInfoCompleteBlock)block
{
    self.method = methodName;
    self.params = params;
    self.block = block;
    [self loadData];
}

#pragma mark - KOGAPIManager
- (NSString *)methodName
{
    return self.method;
}

- (NSString *)serviceType
{
    return kWWWXService;
}

- (KOGAPIManagerRequestType)requestType
{
    return KOGAPIManagerRequestTypeGet;
}

#pragma mark - KOGAPIManagerParamSource
- (NSDictionary *)paramsForApi:(KOGAPIBaseManager *)mamanger
{
    return self.params;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    NSString *contentString = manager.response.contentString;
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSString *title = [[hpple peekAtSearchWithXPathQuery:@"//title"] text];
    NSString *author = [[hpple peekAtSearchWithXPathQuery:@"//strong[@class='profile_nickname']"] text];
    NSString *wxID = [[hpple peekAtSearchWithXPathQuery:@"//span[@class='profile_meta_value']"] text];
    // 获取 bigImageUrl
    NSString *bigImageUrlRegex = @"var\\smsg_cdn_url\\s=\\s\"(.*)\"";
    NSRegularExpression *bigImageUrlRegular = [NSRegularExpression regularExpressionWithPattern:bigImageUrlRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *bigImageUrlMatches = [bigImageUrlRegular matchesInString:contentString options:0 range:NSMakeRange(0, contentString.length)];
    NSString *bigImageUrl = nil;
    if (bigImageUrlMatches && bigImageUrlMatches.count>0) {
        NSRange range = [[bigImageUrlMatches firstObject] rangeAtIndex:1];
        bigImageUrl = [contentString substringWithRange:range];
    }
    
    // 获取 overwrite
    NSString *overviewRegex = @"var\\smsg_desc\\s=\\s\"(.*)\"";
    NSRegularExpression *overviewRegular = [NSRegularExpression regularExpressionWithPattern:overviewRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *overviewMatches = [overviewRegular matchesInString:contentString options:0 range:NSMakeRange(0, contentString.length)];
    NSString *overview = nil;
    if (overviewMatches && overviewMatches.count>0) {
        NSRange range = [[overviewMatches firstObject] rangeAtIndex:1];
        overview = [contentString substringWithRange:range];
    }
    
    // 获取 stamp
    NSString *timeStampRegex = @"var\\sct\\s=\\s\"(.*)\"";
    NSRegularExpression *timeStampRegular = [NSRegularExpression regularExpressionWithPattern:timeStampRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *timeStampMatches = [timeStampRegular matchesInString:contentString options:0 range:NSMakeRange(0, contentString.length)];
    NSString *timeStamp = nil;
    if (timeStampMatches && timeStampMatches.count>0) {
        NSRange range = [[timeStampMatches firstObject] rangeAtIndex:1];
        timeStamp = [contentString substringWithRange:range];
    }
    
    WWArticleItemModel *model = [[WWArticleItemModel alloc] init];
    model.title = title;
    model.author = author;
    model.wxID = wxID;
    model.authorMainUrl = self.authorMainUrl;
    model.contentUrl = self.contentUrl;
    model.bigImageUrl = bigImageUrl;
    model.overview = overview;
    model.timeStamp = timeStamp;
    self.articleInfo = model;
    
    if (self.block) {
        self.block(self);
    }
}

- (void)managerCallAPIDidFailed:(KOGAPIBaseManager *)manager
{
    if (self.block) {
        self.block(self);
    }
    NSLog(@"failed");
}

#pragma mark - setter & getter

@end
