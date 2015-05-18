//
//  ViewController.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDeal.h"


@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *dealCount;


- (void)updateDeal;

@end

