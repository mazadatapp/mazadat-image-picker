package com.mazadatimagepicker.Camera.Gallery;

import android.graphics.Bitmap;
import android.graphics.RectF;

import java.io.File;

public class GalleryItemModel {
  RectF cropView;
  int percentage;
  Bitmap bitmap;
  Boolean cropped = false;
  File croppedFile;
  float zoomPercentage = 1;

  public GalleryItemModel(Bitmap bitmap, int percentage, float zoomPercentage) {
    this.bitmap = bitmap;
    this.percentage = percentage;
    this.zoomPercentage = zoomPercentage;
  }

  public RectF getCropView() {
    return cropView;
  }

  public void setCropView(RectF cropView) {
    this.cropView = cropView;
  }

  public Bitmap getBitmap() {
    return bitmap;
  }

  public int getPercentage() {
    return percentage;
  }

  public Boolean isCropped() {
    return cropped;
  }

  public void setCropped(Boolean cropped) {
    this.cropped = cropped;
  }

  public File getCroppedFile() {
    return croppedFile;
  }

  public void setCroppedFile(File croppedFile) {
    this.croppedFile = croppedFile;
  }

  public float getZoomPercentage() {
    return zoomPercentage;
  }

  public void setZoomPercentage(float zoomPercentage) {
    this.zoomPercentage = zoomPercentage;
  }
}
