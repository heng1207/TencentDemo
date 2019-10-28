//
//  AppDelegate.m
//  LiveOCDemo
//
//  Created by 张恒 on 2019/6/13.
//  Copyright © 2019 张恒. All rights reserved.
//

#import "AppDelegate.h"

#import <ImSDK/ImSDK.h>
#import "TUIKit.h"
#import "THeader.h"
#import "TUIKitConfig.h"
#import "TXLiteAVSDK_Professional/TXLiteAVSDK.h"
#import "TXLiteAVSDK_Professional/TRTCCloud.h"
#import "TXLiteAVSDK_Professional/TRTCCloudDelegate.h"


#import "Replaykit2Define.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    NSString *licenceURL = @"https://license.vod2.myqcloud.com/license/v1/caf72e28f4bc3d0d2695c7c741d473bd/TXLiveSDK.licence";
    NSString *licenceKey = @"0f74e2c695ddeb27a89be96d705f783c";
    [TXLiveBase setLicenceURL:licenceURL key:licenceKey];
    
    
    
    //For ReplayKit2. 使用 UNUserNotificationCenter 来管理通知
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //监听回调事件
        center.delegate = self;
        
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
    }
    
    
    // Override point for customization after application launch.
    return YES;
}


-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    // 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    if (notification.request.content.userInfo.allKeys.count > 0) {
        if ([notification.request.content.userInfo[kReplayKit2UploadingKey] isEqualToString:kReplayKit2Stop]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kCocoaNotificationNameReplayKit2Stop object:nil];
        }
    }
    completionHandler(UNNotificationPresentationOptionSound + UNNotificationPresentationOptionBadge + UNAuthorizationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    if (response.notification.request.content.userInfo.allKeys.count > 0) {
        //        NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:kReplayKit2AppGroupId];
        //        if ([response.notification.request.content.userInfo[kReplayKit2UploadingKey] isEqualToString:kReplayKit2Uploading]) {
        //            [defaults setObject:kReplayKit2Uploading forKey:kReplayKit2UploadingKey];
        //            [defaults synchronize];
        //        }
    }
    completionHandler();
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
