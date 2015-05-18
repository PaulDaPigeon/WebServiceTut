//
//  App.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/18/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AppDeal, Screenshot;

@interface App : NSManagedObject

@property (nonatomic, retain) NSNumber * appDealScore;
@property (nonatomic, retain) NSString * appstreamURL;
@property (nonatomic, retain) NSNumber * avarageUserRatingForAllVersion;
@property (nonatomic, retain) NSNumber * avarageUserRatingForCurrentVersion;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSNumber * currentPrice;
@property (nonatomic, retain) NSDate * currentPriceDate;
@property (nonatomic, retain) NSString * downloadURL;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * iconLarge;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * primaryCategoryId;
@property (nonatomic, retain) NSString * primaryCategoryTitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userRatingForAllVersion;
@property (nonatomic, retain) NSNumber * userRatingForCurrentVersion;
@property (nonatomic, retain) AppDeal *appDeal;
@property (nonatomic, retain) NSSet *screenshots;
@end

@interface App (CoreDataGeneratedAccessors)

- (void)addScreenshotsObject:(Screenshot *)value;
- (void)removeScreenshotsObject:(Screenshot *)value;
- (void)addScreenshots:(NSSet *)values;
- (void)removeScreenshots:(NSSet *)values;

@end
