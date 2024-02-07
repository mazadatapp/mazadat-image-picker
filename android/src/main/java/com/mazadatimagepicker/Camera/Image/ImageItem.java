package com.mazadatimagepicker.Camera.Image;

import android.graphics.Bitmap;

import com.mazadatimagepicker.Camera.CustomViews.ZoomImage;

import java.io.File;

public class ImageItem {
  int imageWidth;
  int imageHeight;
  boolean isEdited = false;
  boolean updateZoomOnce = false;
  ZoomImage zoomImage;
  float zoomLevel = 1;
  private File file;
  private File finalFile;
  private File adapterFile;
  private String url;
  private Bitmap bitmap;
  private int percentage = 100;

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

  public boolean isEdited() {
    return isEdited;
  }

  public void setEdited(boolean edited) {
    isEdited = edited;
  }

  public ZoomImage getZoomImage() {
    return zoomImage;
  }

  public void setZoomImage(ZoomImage zoomImage) {
    this.zoomImage = zoomImage;
  }

  public boolean isUpdateZoomOnce() {
    return updateZoomOnce;
  }

  public void setUpdateZoomOnce(boolean updateZoomOnce) {
    this.updateZoomOnce = updateZoomOnce;
  }

  public float getZoomLevel() {
    return zoomLevel;
  }

  public void setZoomLevel(float zoomLevel) {
    this.zoomLevel = zoomLevel;
  }

  public File getAdapterFile() {
    return adapterFile;
  }

  public void setAdapterFile(File adapterFile) {
    this.adapterFile = adapterFile;
  }

  public File getFinalFile() {
    return finalFile;
  }

  public void setFinalFile(File finalFile) {
    this.finalFile = finalFile;
  }

  public Bitmap getBitmap() {
    return bitmap;
  }

  public void setBitmap(Bitmap bitmap) {
    this.bitmap = bitmap;
  }
}
