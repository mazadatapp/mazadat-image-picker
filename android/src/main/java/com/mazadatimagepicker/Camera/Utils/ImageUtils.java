package com.mazadatimagepicker.Camera.Utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.util.Log;

import androidx.exifinterface.media.ExifInterface;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.UUID;

public class ImageUtils {

  public static File bitmapToFile(Context context, Bitmap bitmap) {
    File file = new File(context.getCacheDir(), UUID.randomUUID().toString() + ".jpg");
    try {
      file.createNewFile();
    } catch (IOException e) {
      e.printStackTrace();
    }

    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    bitmap.compress(Bitmap.CompressFormat.PNG, 0 /*ignored for PNG*/, bos);
    byte[] bitmapdata = bos.toByteArray();

    try {
      FileOutputStream fos = new FileOutputStream(file);
      fos.write(bitmapdata);
      fos.flush();
      fos.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    return file;
  }

  public static Bitmap rotateBitmap(Bitmap bitmap, int angle) {
    Matrix matrix = new Matrix();
    matrix.postRotate(angle);
    Bitmap scaledBitmap = Bitmap.createScaledBitmap(bitmap, bitmap.getWidth(), bitmap.getHeight(), true);
    Bitmap rotatedBitmap = Bitmap.createBitmap(scaledBitmap, 0, 0, scaledBitmap.getWidth(), scaledBitmap.getHeight(), matrix, true);
    return rotatedBitmap;
  }

  public static Bitmap createBitmap(int width, int height, Bitmap capturedBitmap) {
    Bitmap returnedBitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
    Canvas canvas = new Canvas(returnedBitmap);
    canvas.drawColor(Color.BLACK);
    Bitmap bitmap;
    if (capturedBitmap.getHeight() > capturedBitmap.getWidth()) {
      bitmap = Bitmap.createScaledBitmap(capturedBitmap, (int) ((float) returnedBitmap.getHeight() / (float) capturedBitmap.getHeight() * capturedBitmap.getWidth()), returnedBitmap.getHeight(), false);
      canvas.drawBitmap(bitmap, returnedBitmap.getWidth() / 2f - bitmap.getWidth() / 2f, 0, new Paint());
    } else if (height < capturedBitmap.getHeight()) {
      bitmap = Bitmap.createScaledBitmap(capturedBitmap, (int) (((float) returnedBitmap.getHeight() / (float) capturedBitmap.getHeight()) * capturedBitmap.getWidth()), height, false);
      canvas.drawBitmap(bitmap, returnedBitmap.getWidth() / 2f - bitmap.getWidth() / 2f, 0, new Paint());
    } else {
      bitmap = Bitmap.createScaledBitmap(capturedBitmap, returnedBitmap.getWidth(), (int) ((float) returnedBitmap.getWidth() / (float) capturedBitmap.getWidth() * capturedBitmap.getHeight()), false);
      canvas.drawBitmap(bitmap, 0, returnedBitmap.getHeight() / 2f - bitmap.getHeight() / 2f, new Paint());
    }


    return returnedBitmap;

  }

  public static Bitmap checkBitmapIfRotated(Bitmap bitmap, String path) {

    ExifInterface exif = null;
    try {
      exif = new ExifInterface(path);
    } catch (IOException e) {
      e.printStackTrace();
    }
    int orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION,
      ExifInterface.ORIENTATION_UNDEFINED);
    Log.i("datadata_orientation", orientation + "");
    Matrix matrix = new Matrix();
    switch (orientation) {
      case ExifInterface.ORIENTATION_FLIP_HORIZONTAL:
        matrix.setScale(-1, 1);
        break;
      case ExifInterface.ORIENTATION_ROTATE_180:
        matrix.setRotate(180);
        break;
      case ExifInterface.ORIENTATION_FLIP_VERTICAL:
        matrix.setRotate(180);
        matrix.postScale(-1, 1);
        break;
      case ExifInterface.ORIENTATION_TRANSPOSE:
        matrix.setRotate(90);
        matrix.postScale(-1, 1);
        break;
      case ExifInterface.ORIENTATION_ROTATE_90:
        matrix.setRotate(90);
        break;
      case ExifInterface.ORIENTATION_TRANSVERSE:
        matrix.setRotate(-90);
        matrix.postScale(-1, 1);
        break;
      case ExifInterface.ORIENTATION_ROTATE_270:
        matrix.setRotate(-90);
        break;
      default:
        return bitmap;
    }
    try {
      Bitmap bmRotated = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
      bitmap.recycle();
      return bmRotated;
    } catch (OutOfMemoryError e) {
      e.printStackTrace();
      return null;
    }
  }
}
