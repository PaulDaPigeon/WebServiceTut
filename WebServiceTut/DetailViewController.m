//
//  DetailViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/27/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController () <ScreenshotCollectionViewControllerDelegate>

@end

@implementation DetailViewController
{
    NSArray *screenshotURLArray;
    NSMutableArray *screenshotImageArray;
    NSIndexPath *indexOfScreenshotToDisplay;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfScreenshotToDisplay = indexPath;
    
    [self performSegueWithIdentifier:@"ShowScreenshotGallery" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"ShowScreenshotGallery"])
    {
        ScreenshotCollectionViewController *screenshotCollectionViewController = segue.destinationViewController;
        screenshotCollectionViewController.delegate = self;
        screenshotCollectionViewController.screenshotURLArray = screenshotURLArray;
        screenshotCollectionViewController.screenshotImageArray = screenshotImageArray;
        screenshotCollectionViewController.indexOfScreenshotToDisplay = indexOfScreenshotToDisplay;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return screenshotURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenshotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if ([screenshotImageArray count] != 0 && [screenshotImageArray count] - 1 >= indexPath.row)
    {
        cell.screenshot.image = [screenshotImageArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
                   {
                       Screenshot *screenshot = [screenshotURLArray objectAtIndex:indexPath.row];
                       
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
                                          [screenshotImageArray addObject: cell.screenshot.image];
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

- (void) downloadAndDisplayIcon
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
                   {
                       NSURL *url = [NSURL URLWithString:self.app.iconLargeURL];
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
                                              self.appIcon.image = [UIImage imageWithData:data];
                                          });
                       }
                       else
                       {
                           NSLog(@"Could not download icon with error: %@", error);
                       }
                   });
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.topItem.title = self.app.title;
    
    self.titleLabel.text = self.app.title;
    self.categoryLabel.text = self.app.primaryCategoryTitle;
    self.currentPriceLabel.text = [NSString stringWithFormat:@"%@", self.app.currentPrice];
    self.previousPriceLabel.text = [NSString stringWithFormat:@"%@", self.app.previousPrice];
    
    [self downloadAndDisplayIcon];
    [self updateCurrentVersionRatingLabel];
    [self updateAllVersionRatingLabel];
    [self updatePriceAgeLabel];
    
    screenshotURLArray = self.app.screenshots.allObjects;
    screenshotImageArray = [NSMutableArray array];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.collectionView scrollToItemAtIndexPath:indexOfScreenshotToDisplay atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}


- (void) screenshotCollectionViewWillDismissWithImageArray:(NSMutableArray *)newScreenshotImageArray withSelectedImageIndex:(NSIndexPath *)newIndexOfScreenshotToDisplay
{
    screenshotImageArray = newScreenshotImageArray;
    indexOfScreenshotToDisplay = newIndexOfScreenshotToDisplay;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
