//
//  KOGURLResponse.h
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/8.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, KOGURLResponseStatus)
{
    KOGURLResponseStatusSuccess,
    KOGURLResponseStatusErrorTimeout,
    KOGURLResponseStatusErrorNoNetwork
};

@interface KOGURLResponse : NSObject

@property (nonatomic, assign, readonly) KOGURLResponseStatus status;
@property (nonatomic, assign, readonly) NSInteger requestId;

@property (nonatomic, copy, readonly) NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithResponseString:(NSString *)responseString requestID:(NSNumber *)requestID request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;



@end
