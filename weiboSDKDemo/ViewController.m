//
//  ViewController.m
//  weiboSDKDemo
//
//  Created by 张国荣 on 16/6/21.
//  Copyright © 2016年 BateOrganization. All rights reserved.
//

#import "ViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"

#define APP_REDIRECT_URL @"在微博开发者后台，填写的回调地址"
#define APP_KEY @"APP KEY"
@interface ViewController ()<WeiBoDelegate>
{
    AppDelegate *delgate;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    delgate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)weiboLoginAction:(id)sender {
    
    delgate.weiboDelegate = self;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    
    //回调地址与 新浪微博开放平台中 我的应用  --- 应用信息 -----高级应用    -----授权设置 ---应用回调中的url保持一致就好了
    request.redirectURI = APP_REDIRECT_URL;
    
    //SCOPE 授权说明参考  http://open.weibo.com/wiki/
    request.scope = @"all";
    request.userInfo = nil;
    [WeiboSDK sendRequest:request];
}


-(void)weiboLoginByResponse:(WBBaseResponse *)response{
    NSDictionary *dic = (NSDictionary *) response.requestUserInfo;
    NSLog(@"userinfo %@",dic);
    
}


- (IBAction)weiboShareAction:(id)sender {

    //微博分享、需要授权
    WBAuthorizeRequest *authorize = [WBAuthorizeRequest request];
    authorize.redirectURI = @"3125116264";
    authorize.scope = @"all";
    authorize.userInfo = nil;
    
    
    WBMessageObject *message = [WBMessageObject message];
    //分享的具体描述内容
    message.text = @"微博分享测试";
    /** 分享的内容分为两种 ， 消息的图片内容， 还有一种是消息的多媒体内容
      消息的图片内容
      @see WBImageObject
     
      消息的多媒体内容
      @see WBBaseMediaObject
           WBVideoObject   消息中包含的视频数据对象
           WBMusicObject   消息中包含的音乐数据对象
           WBWebpageObject 消息中包含的网页数据对象
     */
    
    //第一种分享方式：  消息的图片内容
//    UIImage* image2 = [UIImage imageNamed:@"首饰.jpg"];
//    WBImageObject *imageObject = [WBImageObject object];
//    imageObject.imageData = UIImageJPEGRepresentation(image2, 1.0);
//    message.imageObject = imageObject;
    
    //第二种分享方式： 多媒体内容分享
    WBWebpageObject *webObject = [WBWebpageObject object];
    // 不能为空，否则会失败
    webObject.webpageUrl = @"http://www.baidu.com";
    webObject.objectID = @"dd";
    //title 不能为空
    webObject.title = @"分享";
    webObject.description = @"详情内容---哈哈哈";
    //缩略图
//    webObject.thumbnailData = UIImageJPEGRepresentation(image2, 1.0);
    message.mediaObject = webObject;
    
    /**
     返回一个 WBSendMessageToWeiboRequest 对象
     
     当用户安装了可以支持微博客户端內分享的微博客户端时,会自动唤起微博并分享
     当用户没有安装微博客户端或微博客户端过低无法支持通过客户端內分享的时候会自动唤起SDK內微博发布器
     
     @param message 需要发送给微博的消息对象
     @param authRequest 授权相关信息,与access_token二者至少有一个不为空,当access_token为空并且需要弹出SDK內发布器时会通过此信息先进行授权后再分享
     @param access_token 第三方应用之前申请的Token,当此值不为空并且无法通过客户端分享的时候,会使用此token进行分享。
     @return 返回一个*自动释放的*WBSendMessageToWeiboRequest对象
     */
    
    WBSendMessageToWeiboRequest *weiboRequest = [WBSendMessageToWeiboRequest requestWithMessage:message
                                                                                   authInfo:authorize
                                                                                access_token:nil];
//    WBSendMessageToWeiboRequest *weiboRequest = [WBSendMessageToWeiboRequest requestWithMessage:message];
    weiboRequest.userInfo = nil;
    delgate.weiboDelegate = self;
   BOOL isSuccess =  [WeiboSDK sendRequest:weiboRequest];
    NSLog(@"分享是否成功 %d",isSuccess);
}

#pragma mark 微博分享 代理回调。
/* 回调时候 代码说明

WeiboSDKResponseStatusCodeSuccess               = 0,//成功
WeiboSDKResponseStatusCodeUserCancel            = -1,//用户取消发送
WeiboSDKResponseStatusCodeSentFail              = -2,//发送失败
WeiboSDKResponseStatusCodeAuthDeny              = -3,//授权失败
WeiboSDKResponseStatusCodeUserCancelInstall     = -4,//用户取消安装微博客户端
WeiboSDKResponseStatusCodePayFail               = -5,//支付失败
WeiboSDKResponseStatusCodeShareInSDKFailed      = -8,//分享失败 详情见response UserInfo
WeiboSDKResponseStatusCodeUnsupport             = -99,//不支持的请求
WeiboSDKResponseStatusCodeUnknown               = -100,

 */
-(void)weiboShareSuccessCode:(NSInteger)shareResultCode{
    NSLog(@"result code %ld",(long)shareResultCode);
    if (shareResultCode == 0) {
        UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"分享成功" message:@"恭喜，获取优惠券一张" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [aler show];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
