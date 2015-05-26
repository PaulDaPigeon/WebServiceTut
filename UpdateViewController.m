//
//  UpdateViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/26/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import "UpdateViewController.h"

@interface UpdateViewController ()

@end

@implementation UpdateViewController
{
    NSManagedObjectContext *context;
    NSEntityDescription *entityDescription;
    AppDeal *dealDataBase;
}

- (void)updateDealAndLabels;
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
                       if (dealDataBase == nil || [dealDataBase.refreshedAt compare: refreshedAt] != NSOrderedSame)
                       {
                           if (dealDataBase != nil)
                           {
                               [context deleteObject:dealDataBase];
                           }
                           dealDataBase = [[AppDeal alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
                           
                           dealDataBase.dealCount = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"deal_count"];
                           dealDataBase.dataURL = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"data_url"];
                           dealDataBase.refreshedAt =refreshedAt;
                           
                           url = [NSURL URLWithString:dealDataBase.dataURL];
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
                           int iterator;
                           dispatch_async(dispatch_get_main_queue(), ^
                                          {
                                              [self updateLabelsWithString:@"Downloading app info"];
                                              [self.activityIndicatorView stopAnimating];
                                              self.progressView.hidden = NO;
                                          });
                           
                           for (id appObject in appArray)
                           {
                               iterator++;
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  [self.progressView setProgress:(iterator / dealDataBase.dealCount.floatValue) animated:YES];
                                              });
                               
                               App *app = [[App alloc] initWithEntity:[NSEntityDescription entityForName:@"App" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                               
                               app.iD = [appObject objectForKey:@"id"];
                               app.title = [appObject objectForKey:@"title"];

                               app.downloadURL = [appObject objectForKey:@"download_url"];
                               app.appstreamURL = [appObject objectForKey:@"appstream_url"];
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
                               
                               url = [NSURL URLWithString:[appObject objectForKey:@"icon"]];
                               request = [NSURLRequest requestWithURL:url];
                               request = [NSURLRequest requestWithURL:url];
                               data = [NSURLConnection sendSynchronousRequest:request
                                                            returningResponse:&response
                                                                        error:&error];
                               
                               app.icon = data;
                               url = [appObject objectForKey:@"iconLarge"];
                               request = [NSURLRequest requestWithURL:url];
                               data = [NSURLConnection sendSynchronousRequest:request
                                                            returningResponse:&response
                                                                        error:&error];
                               app.iconLarge = data;
                               
                               NSArray *screenshotArray = [appObject objectForKey:@"screenshots"];
                               for (NSString *screenshotString in screenshotArray)
                               {
                                   Screenshot *screenshot = [[Screenshot alloc] initWithEntity:[NSEntityDescription entityForName:@"Screenshot" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                                   screenshot.screenshotURL = screenshotString;
                                   
                                   [app addScreenshotsObject:screenshot];
                               }
                               
                               [dealDataBase addAppsObject:app];
                           }
                           
                           [self saveAppDeal];
                       }
                       else
                       {
                           NSLog(@"The deal database is up to date");
                       }
                       
                       dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          [self updateLabelsWithString:@"Deal information up to date!"];
                                          [self.activityIndicatorView stopAnimating];
                                      });
                       [self performSegueWithIdentifier:@"listSegue" sender:self];
                   });
}

- (void) updateLabelsWithString: (NSString*)text
{
    self.statusLabel.text = text;
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
                dealDataBase = (AppDeal *) object;
            }
        }
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"listSegue"])
    {
        ViewController *viewController = segue.destinationViewController;
        viewController.apps = [dealDataBase.apps allObjects];
        viewController.refreshedAt = dealDataBase.refreshedAt;
        viewController.dealCount = dealDataBase.dealCount;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidesWhenStopped = YES;
    
    context = [(AppDeal *) [[UIApplication sharedApplication] delegate] managedObjectContext];
    entityDescription = [NSEntityDescription entityForName:@"AppDeal" inManagedObjectContext:context];
    [self fetchDeal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateDealAndLabels];
}

@end
