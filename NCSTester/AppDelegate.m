//
//  AppDelegate.m
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "AppDelegate.h"

#import "DebugViewController.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 
     _ViewController = [[ViewController alloc] init];
     self.window.rootViewController = _ViewController;
 
   // _rootViewController = [[RootViewController alloc] init];
   // self.window.rootViewController = _rootViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"url: %@", url);
    
    // dismiss previous test previous view controller
    [_rootViewController dismissViewControllerAnimated:NO completion:nil];
    
    // parse url into dictionary
    NSDictionary *dict = [self parseAdminURL:url];
    
    // present new test view controller
    ViewController *viewController = [[ViewController alloc] initWithData:dict];
    
    [_rootViewController presentViewController:viewController animated:NO completion:nil];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSDictionary *)parseAdminURL:(NSURL *)url
{
    // parse url
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSMutableArray *urlComponents = [NSMutableArray arrayWithArray:[url.description componentsSeparatedByString:@"&"]];
    // remove url scheme from variables
    [urlComponents removeObjectAtIndex:0];
    
    for (NSInteger i = 0; i < urlComponents.count; i++) {
        NSArray *pairComponents = [urlComponents[i] componentsSeparatedByString:@"="];
        NSString *key = [[pairComponents objectAtIndex:0] stringByRemovingPercentEncoding];
        id value;
        if (i == 0) {
            value = [[pairComponents objectAtIndex:1] stringByRemovingPercentEncoding];
            value = [value componentsSeparatedByString:@","];
        } else {
            value = [[pairComponents objectAtIndex:1] stringByRemovingPercentEncoding];
        }
        [dict setObject:value forKey:key];
    }
    
    return dict;
}

@end
