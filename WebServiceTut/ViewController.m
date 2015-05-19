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
            self.dealDataBase.dealCount = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"deal_count"];
            self.dealDataBase.dataURL = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"data_url"];
            self.dealDataBase.refreshedAt =refreshedAt;
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
            //No database exists on phone, insert one on the phone
            self.dealDataBase = [[AppDeal alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
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
