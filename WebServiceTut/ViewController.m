//
//  ViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//
#import "ViewController.h"

@interface ViewController () {
    NSManagedObjectContext *context;
    NSEntityDescription *entityDescription;
}
@property (nonatomic, strong) AppDeal *dealDataBase;
@end

@implementation ViewController

- (void)updateDeal;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
    {
        NSDictionary *dealDict;
        NSURL *url = [NSURL URLWithString:@"http://www.goappstream.com/api/v1/app_deals.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        if (error == nil)
        {
            dealDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        }
        else
        {
            NSLog(@"Could not update deal information with error: %@", error);
        }
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'H:m:sZ"];
        NSDate *refreshedAt = [formatter dateFromString:[[dealDict objectForKey:@"mac_app_deals"] objectForKey: @"refreshed_at"]];
        if (self.dealDataBase == nil || [self.dealDataBase.refreshedAt compare: refreshedAt] != NSOrderedSame)
        {
            if (self.dealDataBase != nil)
            {
                [context deleteObject:self.dealDataBase];
            }
            self.dealDataBase = [[AppDeal alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
            
            self.dealDataBase.dealCount = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"deal_count"];
            self.dealDataBase.dataURL = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"data_url"];
            self.dealDataBase.refreshedAt =refreshedAt;
            
            url = [NSURL URLWithString:self.dealDataBase.dataURL];
            request = [NSURLRequest requestWithURL:url];
            data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
            if (error == nil)
            {
                dealDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
            else
            {
                NSLog(@"Could not update app information with error: %@", error);
            }
            
            NSArray *appArray = [dealDict objectForKey:@"apps"];
            for (id appObject in appArray)
            {
                App *app = [[App alloc] initWithEntity:[NSEntityDescription entityForName:@"App" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                
                app.iD = [appObject objectForKey:@"id"];
                app.title = [appObject objectForKey:@"title"];
                app.downloadURL = [appObject objectForKey:@"download_url"];
                app.appstreamURL = [appObject objectForKey:@"appstream_url"];
                app.icon = [appObject objectForKey:@"icon"];
                app.iconLarge = [appObject objectForKey:@"icon_large"];
                app.primaryCategoryID = [appObject objectForKey:@"primary_category_id"];
                app.primaryCategoryTitle = [appObject objectForKey:@"primary_category_title"];
                app.currentPrice = [NSNumber numberWithFloat:[[appObject objectForKey:@"current_price"]floatValue]];
                app.previousPrice = [NSNumber numberWithFloat:[[appObject objectForKey:@"previous_price"] floatValue]];
                app.currentPriceDate = [formatter dateFromString:[appObject objectForKey:@"current_price_date"] ];
                app.currencyCode = [appObject objectForKey:@"currency_code"];
                app.appDealScore = [NSNumber numberWithFloat:[[appObject objectForKey:@"app_deal_score"] floatValue]];
               
                if ([appObject objectForKey:@"average_user_rating_for_current_version"] != [NSNull null])
                {
                    app.avarageUserRatingForCurrentVersion = [NSNumber numberWithFloat:[[appObject objectForKey:@"average_user_rating_for_current_version"] floatValue]];
                }
                if ([appObject objectForKey:@"user_rating_count_for_current_version"] != [NSNull null])
                {
                    app.userRatingCountForCurrentVersion = [appObject objectForKey:@"user_rating_count_for_current_version"];
                }
                if ([appObject objectForKey:@"average_user_rating_for_all_version"] != [NSNull null])
                {
                    app.avarageUserRatingForAllVersion = [NSNumber numberWithFloat:[[appObject objectForKey:@"average_user_rating_for_all_version"] floatValue]];
                }
                if ([appObject objectForKey:@"user_rating_count_for_all_version"] != [NSNull null])
                {
                    app.userRatingCountForAllVersion = [appObject objectForKey:@"user_rating_count_for_all_version"];
                }
                
                NSArray *screenshotArray = [appObject objectForKey:@"screenshots"];
                for (NSString *screenshotString in screenshotArray)
                {
                    Screenshot *screenshot = [[Screenshot alloc] initWithEntity:[NSEntityDescription entityForName:@"Screenshot" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                    screenshot.screenshotURL = screenshotString;
                    [app addScreenshotsObject:screenshot];
                }
                
                [self.dealDataBase addAppsObject:app];
            }
            
            [self saveAppDeal];
        }
        else
        {
            NSLog(@"The deal database is up to date");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
                [self updateUI];
        });
    });
}

- (void) updateUI
{
    self.dealCount.text = [NSString stringWithFormat: @"Deals: %i", (int)[self.dealDataBase.dealCount integerValue]];
}

- (void)saveAppDeal
{
    NSError *error;
    if (![context save: &error])
    {
        NSLog(@"Could not save with error: %@", error);
    }
    else
    {
        NSLog(@"Save successful");
    }
}

- (void) fetchDeal
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil)
    {
        NSLog(@"Could not fetch objects with error: %@", error);
    }
    else
    {
        if (fetchedObjects.count == 0)
        {
            NSLog(@"No object matched the description");
        }
        else
        {
            for (NSManagedObject *object in fetchedObjects)
            {
                self.dealDataBase = (AppDeal *) object;
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    context = [(AppDeal *) [[UIApplication sharedApplication] delegate] managedObjectContext];
    entityDescription = [NSEntityDescription entityForName:@"AppDeal" inManagedObjectContext:context];
    [self fetchDeal];
    
    [self updateDeal];
    
}
@end
