//
//  AppDelegate.m
//  weiboSDKDemo
//
//  Created by 张国荣 on 16/6/21.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiboSDK.h"
//申请下来的appkey
#define APP_KEY @"APP KEY"

@interface AppDelegate ()<WeiboSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [WeiboSDK registerApp:APP_KEY];
    return YES;
}


// 9.0 后才生效
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{

    return [WeiboSDK handleOpenURL:url delegate:self];
}


#pragma mark 9.0之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
}


/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{ //向微博发送请求
    
    NSLog(@" %@",request.class);
}

/**
 
 微博分享  与 微博登录，成功与否都会走这个方法。 用户根据自己的业务进行处理。
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])  //微博登录的回调
    {
        if ([_weiboDelegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
            [_weiboDelegate weiboLoginByResponse:response];
        }
    }
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {  //微博分享的回调
        
        WBSendMessageToWeiboResponse *res = (WBSendMessageToWeiboResponse *)response;
        if ([_weiboDelegate respondsToSelector:@selector(weiboShareSuccessCode:)]) {
            [_weiboDelegate weiboShareSuccessCode:res.statusCode];
        }
    }
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
