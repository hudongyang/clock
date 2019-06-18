//
//  AppDelegate.m
//  Clock
//
//  Created by hudongyang on 2019/6/10.
//  Copyright © 2019 hudongyang. All rights reserved.
//

#import "AppDelegate.h"
#import "ClockViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = ClockViewController.new;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
