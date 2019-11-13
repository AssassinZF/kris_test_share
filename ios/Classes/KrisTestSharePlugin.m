#import "KrisTestSharePlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@implementation KrisTestSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"kris_test_share"
            binaryMessenger:[registrar messenger]];
  KrisTestSharePlugin* instance = [[KrisTestSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"shareFacebook" isEqualToString:call.method]){
      //构建内容
//      FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
//      linkContent.contentURL = [NSURL URLWithString:@"https://image.baidu.com"];
//      linkContent.contentTitle = @"百度";
//      linkContent.contentDescription = [[NSString alloc] initWithFormat:@"%@",@"星空图片欣赏"];
//      linkContent.imageURL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561310690603&di=6fb462fc7c72ab479061c8045639f87b&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F4034970a304e251fb1a2546da986c9177e3e53c9.jpg"];
//      //分享对话框
//      [FBSDKShareDialog showFromViewController:self withContent:linkContent delegate:self];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

@end
