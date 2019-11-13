#import "KrisTestSharePlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareLinkContent.h>
#import <FBSDKShareKit/FBSDKShareDialog.h>

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
      FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
      content.contentURL = [NSURL URLWithString:@"https://developers.facebook.com"];
//      FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//      dialog.fromViewController = self;
//      dialog.content = content;
//      dialog.mode = FBSDKShareDialogModeShareSheet;
//      [dialog show];
      //      FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//      dialog.fromViewController = self;
//      dialog.content = content;
//      dialog.mode = FBSDKShareDialogModeShareSheet;
//      [dialog show];
  }
  else {
    result(FlutterMethodNotImplemented);
  }
}


- (void)facebookShareWithMessage:(id)message {
//    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//    NSString *contentUrlString = dictionary[@"content_url"];
//    NSString *imageUrlString = dictionary[@"image_url"];
//    NSString *description = dictionary[@"description"];
//    NSString *title = dictionary[@"title"];
//    NSString *quote = dictionary[@"quote"];
//
//    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
//    content.contentURL = [NSURL URLWithString:contentUrlString];
////    content.imageURL = [NSURL URLWithString:imageUrlString];
//    content.contentDescription = description;
//    content.contentTitle = title;
//    content.quote = quote;
//
//    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//    dialog.shareContent = content;
//    dialog.fromViewController = self;
//    dialog.delegate = self;
//    dialog.mode = FBSDKShareDialogModeNative;
//    [dialog show];
}

#pragma mark - FaceBook Share Delegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSString *postId = results[@"postId"];
    FBSDKShareDialog *dialog = (FBSDKShareDialog *)sharer;
    if (dialog.mode == FBSDKShareDialogModeBrowser && (postId == nil || [postId isEqualToString:@""])) {
        // 如果使用webview分享的，但postId是空的，
        // 这种情况是用户点击了『完成』按钮，并没有真的分享
        NSLog(@"Cancel");
    } else {
        NSLog(@"Success");
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
    }
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"Cancel");
}

@end
