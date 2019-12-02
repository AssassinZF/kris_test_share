package com.example.kris_test_share;

import android.app.Activity;
import android.net.Uri;

import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.ShareDialog;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** KrisTestSharePlugin */
public class KrisTestSharePlugin implements MethodCallHandler {

  private Activity activity;
  private static CallbackManager callbackManager;
  private Registrar registrar;

  /**
   * Plugin registration.
   */
  private KrisTestSharePlugin(Registrar registrar) {
    this.activity = registrar.activity();
    this.registrar = registrar;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "kris_test_share");
    channel.setMethodCallHandler(new KrisTestSharePlugin(registrar));
      callbackManager = CallbackManager.Factory.create();

  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String url, msg;

    switch (call.method){
      case "shareFacebook":{
        url = call.argument("url");
        msg = call.argument("msg");
        shareToFacebook(url, msg, result);
      }break;
      default:
        result.notImplemented();
        break;
    }
  }

  /**
   * share to Facebook
   *
   * @param url    String
   * @param msg    String
   * @param result Result
   */
  private void shareToFacebook(String url, String msg, final Result resultcallback) {

    ShareDialog shareDialog = new ShareDialog(activity);
    // this part is optional
    shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
      @Override
      public void onSuccess(Sharer.Result result) {
        System.out.println("--------------------success");
        resultcallback.success("分享成功");
      }

      @Override
      public void onCancel() {
        System.out.println("-----------------onCancel");resultcallback.success("分享取消");
      }

      @Override
      public void onError(FacebookException error) {
        System.out.println("---------------onError");
        resultcallback.success("分享失败");
      }
    });

    ShareLinkContent content = new ShareLinkContent.Builder()
            .setContentUrl(Uri.parse(url))
            .setQuote(msg)
            .build();
    if (ShareDialog.canShow(ShareLinkContent.class)) {
      shareDialog.show(content);
      resultcallback.success("分享成功");
    }else{
      resultcallback.success("分享失败");

    }
  }
}
