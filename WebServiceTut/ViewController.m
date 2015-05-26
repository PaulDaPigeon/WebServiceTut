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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [[self.apps objectAtIndex:indexPath.row] title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexOfAppToDisplay = indexPath;
    [self performSegueWithIdentifier:@"appDetailSegue" sender:tableView];
    
}

- (IBAction)refresh
{
    [self performSegueWithIdentifier:@"updateSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"appDetailSegue"])
    {

    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    self.apps =[self.apps sortedArrayUsingDescriptors:@[sort]];
    
    self.dealCountLabel.text = [NSString stringWithFormat:@"Deals: %li", (long)self.dealCount.integerValue];
    
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
    self.refreshedAtLabel.text = [NSString stringWithFormat:@"Last update %li ago", [breakdownInfo day]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}
@end
