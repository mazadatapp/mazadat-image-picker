package com.mazadatimagepicker.Camera.Gallery;

import android.graphics.Bitmap;
import android.graphics.RectF;

import java.io.File;

public class GalleryItemModel {
  RectF cropView;
  Bitmap bitmap;
  Boolean cropped=false;
  File croppedFile;

  public GalleryItemModel(Bitmap bitmap) {
    this.bitmap = bitmap;
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

  public void setBitmap(Bitmap bitmap) {
    this.bitmap = bitmap;
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
}
