//
//  UpdateViewController.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/26/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDeal.h"
#import "App.h"
#import "Screenshot.h"
#import "ViewController.h"


@interface UpdateViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;

@end
