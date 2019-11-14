#import "KrisTestSharePlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>

@interface KrisTestSharePlugin()<FBSDKSharingDelegate>

@end

@implementation KrisTestSharePlugin{
    UIViewController *_viewController;
    FlutterResult _callbackResult;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"kris_test_share"
            binaryMessenger:[registrar messenger]];
    UIViewController *vc =
    [UIApplication sharedApplication].delegate.window.rootViewController;

  KrisTestSharePlugin* instance = [[KrisTestSharePlugin alloc] initWithViewController:vc];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    _callbackResult = result;
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if([@"shareFacebook" isEqualToString:call.method]){
      [self facebookShareWithMessage:call.arguments];
  }else if([@"shareWhatapp" isEqualToString:call.method]){
      [self whatAppShareWithMessage:call.arguments];

  }
  else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)whatAppShareWithMessage:(id)message {
    NSDictionary *param = (NSDictionary *)message;
//    NSString *url = param[@"url"];
    NSString *msg = param[@"msg"];
    NSString *url = [NSString stringWithFormat:@"whatsapp://send?text=%@", [msg stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]]];
    NSURL *whatsappURL = [NSURL URLWithString: url];
    
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
        _callbackResult(@"分享成功");
    } else {
        // Cannot open whatsapp
        _callbackResult(@"分享失败");
    }

}

- (void)facebookShareWithMessage:(id)message {
    NSDictionary *param = (NSDictionary *)message;
    NSString *url = param[@"url"];
    NSString *msg = param[@"msg"];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:url];
    content.quote = msg;
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = _viewController;
    dialog.shareContent = content;
    dialog.delegate = self;
    dialog.mode = FBSDKShareDialogModeNative;
    [dialog show];

}

#pragma mark - FaceBook Share Delegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    if (results.count < 1) {
        _callbackResult(@"取消分享");
        return;

    }
    NSString *postId = results[@"postId"];
    FBSDKShareDialog *dialog = (FBSDKShareDialog *)sharer;
    if (dialog.mode == FBSDKShareDialogModeBrowser && (postId == nil || [postId isEqualToString:@""])) {
        // 如果使用webview分享的，但postId是空的，
        // 这种情况是用户点击了『完成』按钮，并没有真的分享
        NSLog(@"Cancel");
        _callbackResult(@"取消分享");
    } else {
        NSLog(@"Success");
        _callbackResult(@"分享成功");
    }
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    FBSDKShareDialog *dialog = (FBSDKShareDialog *)sharer;
    if (error == nil && dialog.mode == FBSDKShareDialogModeNative) {
        // 如果使用原生登录失败，但error为空，那是因为用户没有安装Facebook app
        // 重设dialog的mode，再次弹出对话框
        dialog.mode = FBSDKShareDialogModeBrowser;
        [dialog show];
    } else {
        NSLog(@"Failure");
        _callbackResult(@"分享失败");
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"Cancel");
    _callbackResult(@"取消分享");
}

@end
