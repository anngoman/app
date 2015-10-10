//
//  AppDelegate.m
//  app
//
//  Created by Victor Sharov on 12/03/15.
//  Copyright (c) 2015 victorsharov. All rights reserved.
//

#import "AppDelegate.h"
#import <Mapbox-iOS-SDK/Mapbox.h>
#import "SettingsManager.h"

@interface AppDelegate ()

- (void)customizeUI;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[RMConfiguration sharedInstance] setAccessToken:@"sk.eyJ1IjoidmljdG9yc2hhcm92IiwiYSI6ImQ3RWJndk0ifQ.QTfpET55PJDi9S_WVZ0I1w"];
    [self customizeUI];

    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *viewController = nil;
    
    if ([SettingsManager sharedSettingsManager].city) {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"listNavVC"];
    } else {
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"firstVC"];
    }
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:BACKGROUND_COLOR];
    

    return YES;
}

- (void)customizeUI
{
    [[UINavigationBar appearance] setBarTintColor:BACKGROUND_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor],
                                                            NSFontAttributeName            : [UIFont fontWithName:@"HelveticaNeue" size:18] }];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0,-100) forBarMetrics:UIBarMetricsDefault];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"HelveticaNeue" size:10.0f], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [[UITabBar appearance] setBackgroundColor:BACKGROUND_COLOR];
    [[UITabBar appearance] setTintColor:ORANGE_COLOR];
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
