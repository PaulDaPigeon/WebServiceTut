//
//  ViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) AppDeals *deals;
@end

@implementation ViewController

- (IBAction)fetchDeals;
{
    NSURL *url = [NSURL URLWithString:@"http://www.goappstream.com/api/v1/app_deals.json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         if (data.length > 0 && connectionError == nil)
         {
             NSDictionary *dealDict = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             //self.dealCount.text = [NSString stringWithFormat: @"Deals: %@", [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"deal_count"]];
             NSNumber *num = [[dealDict objectForKey:@"mac_app_deals"] objectForKey:@"deal_count"];
             NSLog(@"%i", [num intValue]);
             self.deals.dealCount = [num intValue];
             //NSLog(@"%i", self.deals.dealCount);
             //self.deals.dataUrl = nill;
         }
         else {
             if (data.length == 0){
                 NSLog (@"No data retrieved.");
             }
             else {
                 NSLog (@"%@", connectionError);
             }
         }

     }];
}

- (void) checkDeals;
{
    if (self.deals == nil) {
        [self fetchDeals];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkDeals];
    self.dealCount.text = [NSString stringWithFormat: @"Deals: %i", self.deals.dealCount];
    if (self.deals != nil) NSLog(@"mar nem nill");
    if (self.deals == nil) NSLog(@"meg mindig nill");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
