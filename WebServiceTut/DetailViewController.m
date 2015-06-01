//
//  DetailViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/27/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
{
    NSArray *screenshotArray;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    ScreenshotCell *cell = (ScreenshotCell*) [collectionView cellForItemAtIndexPath:indexPath];
    if (cell.screenshot.image.size.height != 0)
    {
        float scaleRate;
        if (cell.screenshot.image.size.height > cell.screenshot.image.size.width)
        {
            scaleRate = (float) collectionView.frame.size.height / cell.screenshot.image.size.height;
        }
        else if (cell.screenshot.image.size.height < cell.screenshot.image.size.width)
        {
            scaleRate = (float) collectionView.frame.size.width / cell.screenshot.image.size.width;
        }
        else
        {
            if (collectionView.frame.size.height < collectionView.frame.size.width)
            {
                scaleRate = (float) collectionView.frame.size.height / cell.screenshot.image.size.height;
            }
            else
            {
                scaleRate = (float) collectionView.frame.size.width / cell.screenshot.image.size.width;
            }
        }
        return CGSizeMake(cell.screenshot.image.size.width * scaleRate, cell.screenshot.image.size.height * scaleRate);
    }
    else{
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return screenshotArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenshotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
                   {
                       Screenshot *screenshot = [screenshotArray objectAtIndex:indexPath.row];
                       
                       NSURL *url = [NSURL URLWithString:screenshot.screenshotURL];
                       NSURLRequest *request = [NSURLRequest requestWithURL:url];
                       
                       NSURLResponse *response;
                       NSError *error;
                       NSData *data = [NSURLConnection sendSynchronousRequest:request
                                                            returningResponse:&response
                                                                        error:&error];
                       if (!error)
                       {
                        
                           dispatch_async(dispatch_get_main_queue(), ^
                                      {
                                          cell.screenshot.image = [UIImage imageWithData:data];
                                          [collectionView performBatchUpdates:nil completion:nil];
                                      });
                       }
                       else
                       {
                           NSLog(@"Could not download screenshot with error: %@", error);
                       }
                   });
    
    return cell;
}

-(IBAction)download:(id)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:self.app.downloadURL]];

}


- (void) updatePriceAgeLabel
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
    NSDateComponents *breakdownInfo = [calendar components:unitFlags fromDate:self.app.currentPriceDate  toDate:[NSDate date]  options:0];
    
    switch ([breakdownInfo day]) {
        case 0:
            switch ([breakdownInfo hour]) {
                case 0:
                    switch ([breakdownInfo minute]) {
                        case 0:
                            self.priceAgeLabel.text = @"a few seconds";
                            break;
                            
                        case 1:
                            self.priceAgeLabel.text = @"1 minute";
                            break;
                        default:
                            self.priceAgeLabel.text = [NSString stringWithFormat:@"%li minutes", [breakdownInfo minute]];
                            break;
                    }
                    break;
                case 1:
                    self.priceAgeLabel.text = @"1 hour";
                    break;
                default:
                    self.priceAgeLabel.text = [NSString stringWithFormat:@"%li hours", [breakdownInfo hour]];
                    break;
            }
            break;
        case 1:
            self.priceAgeLabel.text = @"1 day";
            break;
            
        default:
            self.priceAgeLabel.text = [NSString stringWithFormat:@"%li days", [breakdownInfo day]];
            break;
    }
}

- (void) updateCurrentVersionRatingLabel
{
    if (self.app.userRatingCountForCurrentVersion == 0)
    {
        self.currentVersionRatingLabel.text = @"No ratings yet";
    }
    else
    {
        self.currentVersionRatingLabel.text = [NSString stringWithFormat:@"%@ based on %@ ratings", self.app.avarageUserRatingForCurrentVersion, self.app.userRatingCountForCurrentVersion];
    }
}

- (void) updateAllVersionRatingLabel
{
    if (self.app.userRatingCountForAllVersion == 0)
    {
        self.allVersionRatingLabel.text = @"No ratings yet";
    }
    else
    {
        self.allVersionRatingLabel.text = [NSString stringWithFormat:@"%@ based on %@ ratings", self.app.avarageUserRatingForAllVersion, self.app.userRatingCountForAllVersion];
    }
    
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.topItem.title = self.app.title;
    
    self.appIcon.image = [UIImage imageWithData:self.app.iconLarge];
    self.titleLabel.text = self.app.title;
    self.categoryLabel.text = self.app.primaryCategoryTitle;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%@", self.app.currentPrice];
    self.previousPriceLabel.text = [NSString stringWithFormat:@"%@", self.app.previousPrice];
    
    [self updateCurrentVersionRatingLabel];
    [self updateAllVersionRatingLabel];
    [self updatePriceAgeLabel];
    
    screenshotArray = self.app.screenshots.allObjects;
}

@end
