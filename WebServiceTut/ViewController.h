//
//  ViewController.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UILabel *dealCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *refreshedAtLabel;
@property (nonatomic, strong) NSArray *apps;
@property (nonatomic, strong) NSNumber *dealCount;
@property (nonatomic, strong) NSDate *refreshedAt;

-(IBAction) refresh;

@end

