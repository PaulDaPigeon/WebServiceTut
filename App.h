//
//  App.h
//  WebServiceTut
//
//  Created by Hebok Pal on 6/1/15.
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
@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSString * iconLargeURL;
@property (nonatomic, retain) NSNumber * iD;
@property (nonatomic, retain) NSNumber * previousPrice;
@property (nonatomic, retain) NSNumber * primaryCategoryID;
@property (nonatomic, retain) NSString * primaryCategoryTitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * userRatingCountForAllVersion;
@property (nonatomic, retain) NSNumber * userRatingCountForCurrentVersion;
@property (nonatomic, retain) AppDeal *appDeal;
@property (nonatomic, retain) NSSet *screenshots;
@end

@interface App (CoreDataGeneratedAccessors)

- (void)addScreenshotsObject:(Screenshot *)value;
- (void)removeScreenshotsObject:(Screenshot *)value;
- (void)addScreenshots:(NSSet *)values;
- (void)removeScreenshots:(NSSet *)values;

@end
