//
//  AppDeal.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/18/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class App;

@interface AppDeal : NSManagedObject

@property (nonatomic, retain) NSString * dataURL;
@property (nonatomic, retain) NSNumber * dealCount;
@property (nonatomic, retain) NSDate * refreshedAt;
@property (nonatomic, retain) NSSet *apps;
@end

@interface AppDeal (CoreDataGeneratedAccessors)

- (void)addAppsObject:(App *)value;
- (void)removeAppsObject:(App *)value;
- (void)addApps:(NSSet *)values;
- (void)removeApps:(NSSet *)values;

@end
