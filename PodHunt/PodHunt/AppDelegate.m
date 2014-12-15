//
//  AppDelegate.m
//  PodHunt
//
//  Created by Louis Tur on 11/14/14.
//  Copyright (c) 2014 com.SRLabs. All rights reserved.
//

#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerController/MMDrawerBarButtonItem.h>
#import "UIColor+HoneyPotColorPallette.h"
#import "AppDelegate.h"
#import "LandingPage_VC.h"
#import "UserSplashPageController.h"
#import "HamburgerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // nav controller and 1st VC
    LandingPage_VC * rootViewController = [[LandingPage_VC alloc] init];
    UINavigationController * rootNavControl = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    // placeholder VC for drawer
    HamburgerViewController * hamburgerMenu = [[HamburgerViewController alloc] init];
    // init this with the UINavigationController & Left Drawer
    MMDrawerController * drawerController = [[MMDrawerController alloc] initWithCenterViewController:rootNavControl leftDrawerViewController:hamburgerMenu];
    
    UIFont * navBarFont = [UIFont fontWithName:@"Avenir" size:24.0];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setBarTintColor:[UIColor eggShellWhite]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSFontAttributeName: navBarFont,
                                                            NSForegroundColorAttributeName : [UIColor deepNavy],
                                                            }];
    [[UINavigationBar appearance] setTintColor:[UIColor bloodOrangeRed]];
    
    // make the MMDrawerController the rootView
    [self.window setRootViewController:drawerController];
    [self.window makeKeyAndVisible];
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
