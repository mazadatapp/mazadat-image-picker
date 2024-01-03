package com.mazadatimagepicker.Camera.Image;

import java.io.File;

public class ImageItem {
  private File file;
  private String url;

  private int percentage=100;
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
}
