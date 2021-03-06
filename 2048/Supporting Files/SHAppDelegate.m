//
//  SHAppDelegate.m
//  2048
//
//  Created by Pulkit Goyal on 15/03/14.
//  Copyright (c) 2014 Shyahi. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import <GameKit/GameKit.h>
#import <iRate/iRate.h>
#import "SHAppDelegate.h"
#import "FBAppCall.h"
#import "SHGameCenterManager.h"
#import "SHGameViewController.h"
#import "SHViewController.h"
#import "UIAlertView+BlocksKit.h"
#import "SHAnalytics.h"

@interface SHAppDelegate ()
@property(nonatomic, strong) SHGameCenterManager *gameCenterManager;
@end

@implementation SHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupLogging];
    [self setupAnalytics];
    [self setupGameCenter];
    [self configureIRate];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    // Handle the user leaving the app while the Facebook login dialog is being shown
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[FBSession activeSession] close];
}

#pragma mark - Push notifications
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[SHAnalytics sharedInstance] addPushDeviceToken:deviceToken];
}

#pragma mark - Setup
- (void)setupAnalytics {
    [self setupUserAnalytics];
    [self setupCrashlytics];
}

- (void)setupUserAnalytics {
    [SHAnalytics sharedInstanceWithToken:@"f5cbb9544ffb2eab524f51901bde5ac8"];
}

- (void)setupCrashlytics {
    [Crashlytics startWithAPIKey:@"3a6eafbc09aeb0ae347350ae99040ae7a42d37b3"];
}

- (void)setupLogging {
    // Configure CocoaLumberjack
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    // Configure colors
#if TARGET_OS_IPHONE
    UIColor *pink = [UIColor colorWithRed:0.44 green:0.24 blue:0.67 alpha:1.0];
    UIColor *green = [UIColor colorWithRed:0.40 green:0.52 blue:0 alpha:1.0];
#else
    NSColor *pink = [NSColor colorWithCalibratedRed:0.44 green:0.24 blue:0.67 alpha:1.0];
    UIColor *green = [UIColor colorWithCalibratedRed:0.40 green:0.52 blue:0 alpha:1.0];
#endif

    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:LOG_FLAG_INFO];
    [[DDTTYLogger sharedInstance] setForegroundColor:green backgroundColor:nil forFlag:LOG_FLAG_VERBOSE];
}

#pragma mark - Facebook
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // After Facebook authentication, app will be called back with the session information.
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

#pragma mark - Game Center
- (void)setupGameCenter {
    self.gameCenterManager = [SHGameCenterManager sharedManager];
    [self.gameCenterManager setupWithAppDelegate:self];
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    UINavigationController *navigationController = (UINavigationController *) self.window.rootViewController;

    if ([navigationController.topViewController isKindOfClass:[SHViewController class]]) {
        // Segue to the game view controller
        [navigationController.topViewController performSegueWithIdentifier:kSHMultiplayerGameSegueIdentifier sender:navigationController.topViewController];
    } else if ([navigationController.topViewController isKindOfClass:[SHGameViewController class]]) {
        // It is the top controller. Just layout this match
        SHGameViewController *gameViewController = (SHGameViewController *) navigationController.topViewController;
        if (gameViewController.isMultiplayer) {
            [gameViewController layoutMatch:match];
        } else {
            // Switch to multiplayer game from a single player game?
            [UIAlertView bk_showAlertViewWithTitle:@"End This Match" message:@"You will loose the current progress when switching to multiplayer mode. Are you sure you want to end this match?" cancelButtonTitle:@"No" otherButtonTitles:@[@"Yes"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 1:
                        // Continue. Switch to multiplayer mode.
                        [gameViewController switchToMultiplayerModeWithMatch:match];
                        break;
                    default:
                        break;

                }
            }];
        }
    } else {
        // TODO Open game view controller from other controllers?
    }
}

#pragma mark iRate
- (void)configureIRate {
    [iRate sharedInstance].daysUntilPrompt = 4;
    [iRate sharedInstance].usesUntilPrompt = 4;
}

@end
