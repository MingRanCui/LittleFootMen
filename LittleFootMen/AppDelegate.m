//
//  AppDelegate.m
//  LittleFootMen
//
//  Created by 崔明燃 on 15/11/6.
//  Copyright © 2015年 崔明燃. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FirstViewController.h"
#import "FMBuildViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *sandboxPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/LFM.plist"];
    NSDictionary *notFirstStartDic = [[NSDictionary alloc] initWithContentsOfFile:sandboxPath];
    BOOL isNotFirstStart = [[notFirstStartDic objectForKey:@"isNotFirstStart"] boolValue];
    if (isNotFirstStart) {
//        ViewController *mainTabBarController = [[ViewController alloc] init];
        FMBuildViewController *mainTabBarController = [[FMBuildViewController alloc] init];
        UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:mainTabBarController];
        self.window.rootViewController = mainNavi;
    } else {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@YES forKey:@"isNotFirstStart"];
        [dic writeToFile:sandboxPath atomically:YES];
        
        FirstViewController *firstVC = [[FirstViewController alloc] init];
        self.window.rootViewController = firstVC;
    }
    
    // 输出 沙盒路径
//    NSString *path = NSHomeDirectory();
//    NSLog(@"%@",path);
    
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
