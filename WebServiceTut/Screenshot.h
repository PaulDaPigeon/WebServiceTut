//
//  Screenshot.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/18/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class App;

@interface Screenshot : NSManagedObject

@property (nonatomic, retain) NSString * screenshotURL;
@property (nonatomic, retain) App *app;

@end
