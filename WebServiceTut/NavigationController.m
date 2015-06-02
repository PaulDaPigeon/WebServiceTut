//
//  NavigationController.m
//  WebServiceTut
//
//  Created by Hebok Pal on 6/2/15.
//  Copyright (c) 2015 Bitfall. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

@end
