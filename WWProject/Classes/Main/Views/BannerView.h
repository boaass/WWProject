//
//  BannerView.h
//  WWProject
//
//  Created by zcl_kingsoft on 2017/9/6.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerData : NSObject

@property (nonatomic, strong) NSString *imageUrl;

@end

@interface BannerView : UIView

@property (nonatomic, strong) NSArray <BannerData *> * bannerList;

@property (nonatomic, copy) void (^tapBlock)(BannerData *bannerData);

- (void)reload;

@end
