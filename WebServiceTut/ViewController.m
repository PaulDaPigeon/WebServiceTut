//
//  ViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//
#import "ViewController.h"

@interface ViewController () {
    NSDictionary *dealDict;
}
@property (nonatomic, strong) AppDeal *deals;
@end

@implementation ViewController

- (IBAction)fetchDeals;
{
    NSURL *url = [NSURL URLWithString:@"http://www.goappstream.com/api/v1/app_deals.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    if (error == nil) {
        dealDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    self.deals.dealCount = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"deal_count"];
    self.deals.dataURL = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"data_url"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'H:m:sZ"];
    self.deals.refreshedAt = [formatter dateFromString:[[dealDict objectForKey:@"mac_app_deals"] objectForKey: @"refreshed_at"]];
}

- (void) checkDeals;
{
    if (self.deals.refreshedAt < [NSDate dateWithTimeIntervalSinceNow:-600]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                       ^{
                           [self fetchDeals];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               self.dealCount.text = [NSString stringWithFormat: @"Deals: %i", (int)[self.deals.dealCount integerValue]];
                           });
                       });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.deals = [[AppDeal alloc] init];
    [self checkDeals];
}


@end
