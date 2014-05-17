//
//  SHAboutViewController.m
//  2048
//
//  Created on 26/04/14.
//  Copyright (c) 2014 Shyahi. All rights reserved.
//

#import "SHAboutViewController.h"
#import "SHAnalytics.h"

@interface SHAboutViewController ()

@end

@implementation SHAboutViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [[SHAnalytics sharedInstance] screen:@"About Screen" properties:nil];
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
