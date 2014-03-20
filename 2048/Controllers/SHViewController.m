//
//  SHViewController.m
//  2048
//
//  Created by Pulkit Goyal on 15/03/14.
//  Copyright (c) 2014 Shyahi. All rights reserved.
//

#import "SHViewController.h"
#import "HexColor.h"
#import "UIImage+ImageWithColor.h"

@interface SHViewController ()

@end

@implementation SHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"INTRO_VIEW_SHOWN"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"INTRO_VIEW_SHOWN"];
        [self showIntroView];
//    } else {
//        [self startGame];
//    }
}

- (void)startGame {
    [self performSegueWithIdentifier:@"SH_GAME_SEGUE" sender:self];
}

- (void)showIntroView {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"One swipe moves all";
    page1.desc = @"Swipe in any direction to move the tiles in that direction";
    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2048-1"]];
    [self styleIntroPage:page1];


    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Join tiles to get 2048";
    page2.desc = @"When two tiles with the same number touch, they merge into one!";
    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"2048-2"]];
    [self styleIntroPage:page2];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1, page2]];
    intro.delegate = self;
    intro.pageControl.currentPageIndicatorTintColor = [[UIColor colorWithHexString:@"#776e65"] colorWithAlphaComponent:0.8];
    intro.pageControl.pageIndicatorTintColor = [[UIColor colorWithHexString:@"#776e65"] colorWithAlphaComponent:0.1];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)styleIntroPage:(EAIntroPage *)page {
    page.bgImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"#faf8ef"]];
    page.titlePositionY = 130.0f;
    page.titleFont = [UIFont fontWithName:@"AvenirNext-Bold" size:20];
    page.titleColor = [UIColor colorWithHexString:@"#776e65"];
    page.descColor = [[UIColor colorWithHexString:@"#776e65"] colorWithAlphaComponent:0.9];
    page.descFont = [UIFont fontWithName:@"Avenir-Light" size:17];
    page.descPositionY = 110.0f;
}

#pragma mark - Intro View Delegate
- (void)introDidFinish:(EAIntroView *)introView {
    // Start game
    [self startGame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
