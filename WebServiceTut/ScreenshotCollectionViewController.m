//
//  ScreenshotCollectionViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 6/1/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import "ScreenshotCollectionViewController.h"

@interface ScreenshotCollectionViewController ()

@end

@implementation ScreenshotCollectionViewController
{
    NSInteger currentIndex;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView scrollToItemAtIndexPath:self.indexOfScreenshotToDisplay atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(screenshotCollectionViewWillDismissWithImageArray:withSelectedImageIndex:)]) {
        [self.delegate screenshotCollectionViewWillDismissWithImageArray:self.screenshotImageArray withSelectedImageIndex: self.indexOfScreenshotToDisplay];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.bounds.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.screenshotURLArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ScreenshotCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    self.indexOfScreenshotToDisplay = indexPath;
    
    if ([self.screenshotImageArray count] != 0 && [self.screenshotImageArray count] - 1 >= indexPath.row)
    {
        cell.screenshot.image = [self.screenshotImageArray objectAtIndex:indexPath.row];
        return cell;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
                   {
                       Screenshot *screenshot = [self.screenshotURLArray objectAtIndex:indexPath.row];
                       
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
                                              [self.screenshotImageArray addObject: cell.screenshot.image];
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

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView setAlpha:0.0f];
    
    CGPoint currentOffset = [self.collectionView contentOffset];
    currentIndex = currentOffset.x / self.collectionView.frame.size.width;
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    float offset = currentIndex * self.collectionView.bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
    
    self.indexOfScreenshotToDisplay = [NSIndexPath indexPathForRow:currentIndex inSection:0];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
