//
//  CTRAppDelegate.m
//  Coffee Timer
//
//  Created by Ash Furrow on 2013-03-16.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "CTRAppDelegate.h"

@implementation CTRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    NSLog(@"Application has launched.");
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"Application has resigned active.");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"Application has entered background.");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"Application has entered foreground.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
