package com.mazadatimagepicker.Camera.Image;

import java.io.File;

public class ImageItem {
  private boolean hasImage=false;
  private File file;

  public ImageItem() {
  }

  public boolean isHasImage() {
    return hasImage;
  }

  public void setHasImage(boolean hasImage) {
    this.hasImage = hasImage;
  }

  public File getFile() {
    return file;
  }

  public void setFile(File file) {
    this.file = file;
  }
}
