//
//  AppDelegate.h
//  weiboSDKDemo
//
//  Created by 张国荣 on 16/6/21.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboSDK.h"
@protocol WeiBoDelegate <NSObject>

//登录的代理
-(void)weiboLoginByResponse:(WBBaseResponse *)response;
//分享的代理
-(void)weiboShareSuccessCode:(NSInteger)shareResultCode;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak  , nonatomic) id<WeiBoDelegate> weiboDelegate;

@end

