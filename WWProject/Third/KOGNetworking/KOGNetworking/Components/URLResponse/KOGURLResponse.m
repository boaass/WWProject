//
//  KOGURLResponse.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/8.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGURLResponse.h"
#import "NSURLRequest+KOGNetworking.h"

@interface KOGURLResponse ()

@property (nonatomic, assign, readwrite) KOGURLResponseStatus status;
@property (nonatomic, assign, readwrite) NSInteger requestId;

@property (nonatomic, copy, readwrite) NSString *contentString;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, copy, readwrite) id content;

@end

@implementation KOGURLResponse

- (instancetype)initWithResponseString:(NSString *)responseString requestID:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error
{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        }
        self.status = [self kog_responseStatusWithError:error];
        self.error = error;
        self.requestId = [requestID integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
    }
    
    return self;
}


#pragma mark - private
- (KOGURLResponseStatus)kog_responseStatusWithError:(NSError *)error
{
    KOGURLResponseStatus status = KOGURLResponseStatusErrorNoNetwork;
    if (error) {
        if (error.code == NSURLErrorTimedOut) {
            status = KOGURLResponseStatusErrorTimeout;
        }
    } else {
        status = KOGURLResponseStatusSuccess;
    }
    
    return status;
}

@end
