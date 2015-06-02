//
//  ViewController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 5/5/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//
#import "ViewController.h"

@interface ViewController () {
    NSInteger *row;
    NSIndexPath *indexOfAppToDisplay;
}
@end

@implementation ViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.apps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[AppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.titleLabel.text = [(App*) [self.apps objectAtIndex:indexPath.row] title];
    [cell.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^
                   {
                       NSURL *url = [NSURL URLWithString:[(App*) [self.apps objectAtIndex:indexPath.row] iconURL]];
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
                                              cell.appIcon.image = [UIImage imageWithData:data];
                                          });
                       }
                       else
                       {
                           NSLog(@"Could not download icon with error: %@", error);
                       }
                   });
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfAppToDisplay = indexPath;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
    
}

- (IBAction)refresh:(id)sender
{
    [self performSegueWithIdentifier:@"updateSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        DetailViewController *detailView = [segue destinationViewController];
        detailView.app = [self.apps objectAtIndex:indexOfAppToDisplay.row];
    }
}

- (void) updateRefreshedAtLabel
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay;
    NSDateComponents *breakdownInfo = [calendar components:unitFlags fromDate:self.refreshedAt  toDate:[NSDate date]  options:0];
    
    switch ([breakdownInfo day]) {
        case 0:
            switch ([breakdownInfo hour]) {
                case 0:
                    switch ([breakdownInfo minute]) {
                        case 0:
                            self.refreshedAtLabel.text = @"Last update: just now";
                            break;
                            
                        case 1:
                            self.refreshedAtLabel.text = @"Last update: 1 minute ago";
                            break;
                        default:
                            self.refreshedAtLabel.text = [NSString stringWithFormat:@"Last update: %li minutes ago", [breakdownInfo minute]];
                            break;
                    }
                    break;
                case 1:
                    self.refreshedAtLabel.text = @"Last update: 1 hour ago";
                    break;
                default:
                    self.refreshedAtLabel.text = [NSString stringWithFormat:@"Last update: %li hours ago", [breakdownInfo hour]];
                    break;
            }
            break;
        case 1:
            self.refreshedAtLabel.text = @"Last update: yesterday";
            break;
            
        default:
            self.refreshedAtLabel.text = [NSString stringWithFormat:@"Last update: %li days ago", [breakdownInfo day]];
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.apps =[self.apps sortedArrayUsingDescriptors:@[sort]];
    
    self.dealCountLabel.text = [NSString stringWithFormat:@"Deals: %li", self.dealCount.integerValue];
    [self updateRefreshedAtLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end
