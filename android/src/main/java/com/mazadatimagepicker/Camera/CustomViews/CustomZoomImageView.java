package com.mazadatimagepicker.Camera.CustomViews;

import android.content.Context;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.widget.ImageView;

import androidx.annotation.Nullable;

public class CustomZoomImageView extends ImageView {
  public CustomZoomImageView(Context context) {
    super(context);
  }

  public CustomZoomImageView(Context context, @Nullable AttributeSet attrs) {
    super(context, attrs);
  }


  public void resetZoom(){

  }

  public void setMinZoom(float value){

  }

  public void setMaxZoom(float value){

  }

  public void setZoom(float value){

  }

  public void setZoom(float value,float centerX,float centerY){

  }

  public void setScrollPosition(float centerX,float centerY){

  }

  public float getCurrentZoom(){
    return 1;
  }

  public RectF getZoomedRect(){
    return new RectF(0f,0f,1f,1f);
  }


}
