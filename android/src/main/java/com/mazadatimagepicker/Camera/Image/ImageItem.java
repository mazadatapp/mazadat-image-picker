package com.mazadatimagepicker.Camera.Image;

import android.graphics.Bitmap;

import java.io.File;

public class ImageItem {
  private File file;
  private String url;

  private int percentage=100;
  int imageWidth;
  int imageHeight;
  Bitmap bitmap;
  public ImageItem() {
  }

  public ImageItem(File file) {
    this.file = file;
  }

  public ImageItem(String url) {
    this.url = url;
  }

  public File getFile() {
    return file;
  }

  public void setFile(File file) {
    this.file = file;
  }

  public String getUrl() {
    return url;
  }

  public void setUrl(String url) {
    this.url = url;
  }

  public int getPercentage() {
    return percentage;
  }

  public void setPercentage(int percentage) {
    this.percentage = percentage;
  }

  public int getImageWidth() {
    return imageWidth;
  }

  public void setImageWidth(int imageWidth) {
    this.imageWidth = imageWidth;
  }

  public int getImageHeight() {
    return imageHeight;
  }

  public void setImageHeight(int imageHeight) {
    this.imageHeight = imageHeight;
  }

  public Bitmap getBitmap() {
    return bitmap;
  }

  public void setBitmap(Bitmap bitmap) {
    this.bitmap = bitmap;
  }
}
