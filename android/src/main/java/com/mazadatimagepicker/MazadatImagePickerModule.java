package com.mazadatimagepicker;

import android.content.Intent;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;
import com.mazadatimagepicker.Camera.CameraActivity;

import java.util.Objects;

@ReactModule(name = MazadatImagePickerModule.NAME)
public class MazadatImagePickerModule extends ReactContextBaseJavaModule {
  public static final String NAME = "MazadatImagePicker";

  public MazadatImagePickerModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }


  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  public void multiply(double a, double b, Promise promise) {
    promise.resolve(a * b);
  }

  @ReactMethod
  public void openCamera(int length, Promise promise) {
    Intent intent = new Intent(getCurrentActivity(), CameraActivity.class);
    intent.putExtra("maxLength", length);

    Objects.requireNonNull(getCurrentActivity()).startActivity(intent);
  }
}
