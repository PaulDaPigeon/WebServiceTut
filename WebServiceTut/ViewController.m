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
@property (nonatomic, strong) AppDeals *deals;
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
    self.deals.dataUrl = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"data_url"];
    NSLog(@"%@", [NSString stringWithFormat:@"%d", (int)[self.deals.dealCount integerValue]]);
}

- (void) checkDeals;
{
    if (self.deals.refreshedAt < [NSDate dateWithTimeIntervalSinceNow:-600]) {
        [self fetchDeals];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.deals = [[AppDeals alloc] init];
    [self checkDeals];
    self.dealCount.text = [NSString stringWithFormat: @"Deals: %i", (int)[self.deals.dealCount integerValue]];
}


@end
