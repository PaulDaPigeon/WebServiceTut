//
//  DetailViewController.h
//  WebServiceTut
//
//  Created by Hebok Pal on 5/27/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "App.h"
#import "ScreenshotCell.h"
#import "Screenshot.h"

@interface DetailViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *previousPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *currentVersionRatingLabel;
@property (nonatomic, strong) IBOutlet UILabel *allVersionRatingLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceAgeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *appIcon;

@property (nonatomic, strong) App *app;

-(IBAction)download:(id)sender;

@end
