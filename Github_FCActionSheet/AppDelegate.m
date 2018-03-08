//
//  AppDelegate.m
//  Github_FCActionSheet
//
//  Created by William Steven Brohawn on 08/03/2018.
//  Copyright © 2018 William Steven Brohawn. All rights reserved.
//

#import "AppDelegate.h"
#import "FCMainViewController.h"

@interface AppDelegate()

@end

@implementation AppDelegate

- (UIWindow *)window
{
    if( _window == nil )
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window setRootViewController:[FCMainViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
