//
//  App.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

    @property int id;
    @property NSString *title;
    @property NSString *downloadUrl;
    @property NSString *appstreamUrl;
    @property NSString *icon;
    @property NSString *iconLarge;
    @property float avarageUserRatingForCurrentVersion;
    @property int userRatingForCurrentVersion;
    @property float avarageUserRatingForAllVersion;
    @property int userRatingForAllVersion;
    @property int primaryCategoryId;
    @property NSString *primaryCategoryTitle;
    @property float currentPrice;
    @property float previousPrice;
    @property NSDate *currentPriceDate;
    @property NSString *currencyCode;
    @property NSArray *screenshots;
    @property float appDealScore;

@end
