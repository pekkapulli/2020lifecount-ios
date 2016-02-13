//
//  AppDelegate.m
//  Life Count
//
//  Created by Pekka Pulli on 11/7/12.
//  Copyright (c) 2012 Pekka Pulli. All rights reserved.
//

#import "AppDelegate.h"
#import "Controller/PKRevealController.h"
#import "ScoreViewController.h"
#import "HistoryViewController.h"
#import "SettingsViewController.h"
#import <Google/Analytics.h>

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Step 1: Create your controllers.
    UIViewController *historyViewController = [[HistoryViewController alloc] init];;
    UIViewController *settingsViewController = [[SettingsViewController alloc] init];
    UIViewController *scoreViewController = [[ScoreViewController alloc] init];
    
    // Step 2: Configure an options dictionary for the PKRevealController if necessary - in most cases the default behaviour should suffice. See PKRevealController.h for more option keys.
    
    NSDictionary *options = @{PKRevealControllerRecognizesPanningOnFrontViewKey : @NO};
    
    // Step 3: Instantiate your PKRevealController.
    self.revealController = [PKRevealController revealControllerWithFrontViewController:scoreViewController leftViewController:settingsViewController rightViewController:historyViewController options:options];
    
    // Step 4: Set it as your root view controller.
    self.window.rootViewController = self.revealController;
    
    [self.window makeKeyAndVisible];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.revealController setMinimumWidth:240.0f maximumWidth:240.0f forViewController:historyViewController];
        [self.revealController setMinimumWidth:320.0f maximumWidth:320.0f forViewController:settingsViewController];
        
    } else {
        [self.revealController setMinimumWidth:240.0f maximumWidth:240.0f forViewController:historyViewController];
        [self.revealController setMinimumWidth:240.0f maximumWidth:240.0f forViewController:settingsViewController];
    }
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    return YES;
    
    // Step 5: Take a look at the Left/RightDemoViewController files. They're self-sufficient as to the configuration of their reveal widths for instance.
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

@end
