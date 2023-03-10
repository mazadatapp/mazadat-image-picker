package com.mazadatimagepicker;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Configuration;
import android.content.res.Resources;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.mazadatimagepicker.Camera.CameraActivity;

import java.util.Locale;
import java.util.Objects;

@ReactModule(name = MazadatImagePickerModule.NAME)
public class MazadatImagePickerModule extends ReactContextBaseJavaModule {
  public static final String NAME = "MazadatImagePicker";

  private Promise promise;
  BroadcastReceiver receiver = new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      promise.resolve(intent.getStringExtra("data"));

    }
  };

  public MazadatImagePickerModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  public static void setLocale(Activity activity, String languageCode) {
    Locale locale = new Locale(languageCode);
    Locale.setDefault(locale);
    Resources resources = activity.getResources();
    Configuration config = resources.getConfiguration();
    config.setLocale(locale);
    activity.getResources().updateConfiguration(config, activity.getResources().getDisplayMetrics());
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }

  // Example method
  // See https://reactnative.dev/docs/native-modules-android

  @ReactMethod
  public void openCamera(int maxImagesSize, String lang, Promise promise) {
    this.promise = promise;
    setLocale(getCurrentActivity(), lang);
    Intent intent = new Intent(getCurrentActivity(), CameraActivity.class);
    intent.putExtra("maxImagesSize", maxImagesSize);
    intent.putExtra("lang", lang);

    Objects.requireNonNull(getCurrentActivity()).startActivity(intent);

    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addAction(BuildConfig.BROADCAST_ACTION);
    getCurrentActivity().registerReceiver(receiver, intentFilter);
  }

  @ReactMethod
  public void editPhoto(String path, String lang, Promise promise) {
    this.promise = promise;
    setLocale(getCurrentActivity(), lang);
    Intent intent = new Intent(getCurrentActivity(), CameraActivity.class);
    intent.putExtra("editOnlyOnePhoto", true);
    intent.putExtra("path", path);
    intent.putExtra("lang", lang);

    Objects.requireNonNull(getCurrentActivity()).startActivity(intent);

    IntentFilter intentFilter = new IntentFilter();
    intentFilter.addAction(BuildConfig.BROADCAST_ACTION);
    getCurrentActivity().registerReceiver(receiver, intentFilter);
  }
}
