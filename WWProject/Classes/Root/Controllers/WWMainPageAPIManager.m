//
//  WWMainPageAPIManager.m
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWMainPageAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWMainPageModel.h"
#import "WWArticleItemModel.h"

@interface WWMainPageAPIManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong) CompleteBlock block;

@end

@implementation WWMainPageAPIManager

- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.paramSource = self;
    }
    
    return self;
}

- (void)loadDataWithBlock:(CompleteBlock)block
{
    [self loadData];
    self.block = block;
}

#pragma mark - KOGAPIManager
- (NSString *)methodName
{
    return @"";
}

- (NSString *)serviceType
{
    return kWWMainPageService;
}

- (KOGAPIManagerRequestType)requestType
{
    return KOGAPIManagerRequestTypeGet;
}

#pragma mark - KOGAPIManagerParamSource
- (NSDictionary *)paramsForApi:(KOGAPIBaseManager *)mamanger
{
    return nil;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSArray *items = [hpple searchWithXPathQuery:@"//a[@class='sd-slider-item']"];
    for (TFHppleElement *element in items) {
        TFHpple *elementHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"%@", [[elementHpple peekAtSearchWithXPathQuery:@"//img"] objectForKey:@"src"]);
        NSLog(@"%@", [[elementHpple peekAtSearchWithXPathQuery:@"//p"] objectForKey:@"title"]);
//        NSLog(@"%@", element.raw);
    }
    
    if (self.block) {
        self.block(manager);
    }
    NSLog(@"success");
}

- (void)managerCallAPIDidFailed:(KOGAPIBaseManager *)manager
{
    if (self.block) {
        self.block(manager);
    }
    NSLog(@"failed");
}

@end
