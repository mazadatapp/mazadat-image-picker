package com.mazadatimagepicker.Camera.CustomViews;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;

import com.jsibbold.zoomage.ZoomageView;
import com.mazadatimagepicker.R;

@SuppressLint("DrawAllocation")
public class ZoomImage extends ZoomageView {

  Paint mainColor;
  public ZoomImage(Context context) {
    super(context);
    init();
  }

  public ZoomImage(Context context, AttributeSet attrs) {
    super(context, attrs);
    init();
  }

  private void init(){
    mainColor = new Paint();
    mainColor.setAntiAlias(true);
    mainColor.setColor(getResources().getColor(R.color.turquoise_blue));
  }

  @Override
  protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);

    RectF cropView = new RectF(0,0, getWidth(), getHeight());
    canvas.drawRect(cropView.left, cropView.top + cropView.height() * 0.33f - 2, cropView.right, cropView.top + cropView.height() * 0.33f + 2, mainColor);
    canvas.drawRect(cropView.left, cropView.top + cropView.height() * 0.66f - 2, cropView.right, cropView.top + cropView.height() * 0.66f + 2, mainColor);
    canvas.drawRect(cropView.left + cropView.width() * 0.33f - 2, cropView.top, cropView.left + cropView.width() * 0.33f + 2, cropView.bottom, mainColor);
    canvas.drawRect(cropView.left + cropView.width() * 0.66f - 2, cropView.top, cropView.left + cropView.width() * 0.66f + 2, cropView.bottom, mainColor);
  }
}
