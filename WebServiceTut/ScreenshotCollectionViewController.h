//
//  ScreenshotCollectionViewController.h
//  WebServiceTut
//
//  Created by Hebok Pal on 6/1/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenshotCell.h"
#import "Screenshot.h"

@protocol ScreenshotCollectionViewControllerDelegate <NSObject>


@required


- (void) screenshotCollectionViewWillDismissWithImageArray:(NSMutableArray *)screenshotImageArray withSelectedImageIndex:(NSIndexPath *)indexOfScreenshotToDisplay;


@end

@interface ScreenshotCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSArray *screenshotURLArray;
@property (nonatomic, strong) NSMutableArray *screenshotImageArray;
@property (nonatomic, strong) NSIndexPath *indexOfScreenshotToDisplay;
@property (nonatomic, weak) id<ScreenshotCollectionViewControllerDelegate> delegate;

@end
