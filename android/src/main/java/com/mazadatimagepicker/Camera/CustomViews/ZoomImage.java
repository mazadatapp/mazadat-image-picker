package com.mazadatimagepicker.Camera.CustomViews;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;

import com.mazadatimagepicker.R;
import com.ortiz.touchview.TouchImageView;

@SuppressLint("DrawAllocation")
public class ZoomImage extends ZoomageView {

  public RectF rect;
  Paint mainColor;
  boolean showGrid = true;
  private ZoomListener zoomListener;
  private float oldScale = -1;

  public ZoomImage(Context context) {
    super(context);
  }

  public ZoomImage(Context context, AttributeSet attrs) {
    super(context, attrs);
    init();
  }

  public void setRect(RectF rect) {
    this.rect = rect;
    invalidate();
  }

  private void init() {
    //setDoubleTapToZoom(false);
    mainColor = new Paint();
    mainColor.setAntiAlias(true);
    mainColor.setColor(getResources().getColor(R.color.turquoise_blue));
    setMaxZoom(150);
  }

  public void setZoomListener(ZoomListener zoomListener) {
    this.zoomListener = zoomListener;
  }

  public void setShowGrid(boolean showGrid) {
    this.showGrid = showGrid;
    invalidate();
  }

  @Override
  protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);

    if (showGrid) {
      RectF cropView = new RectF(0, 0, getWidth(), getHeight());
      canvas.drawRect(cropView.left, cropView.top + cropView.height() * 0.33f - 2, cropView.right, cropView.top + cropView.height() * 0.33f + 2, mainColor);
      canvas.drawRect(cropView.left, cropView.top + cropView.height() * 0.66f - 2, cropView.right, cropView.top + cropView.height() * 0.66f + 2, mainColor);
      canvas.drawRect(cropView.left + cropView.width() * 0.33f - 2, cropView.top, cropView.left + cropView.width() * 0.33f + 2, cropView.bottom, mainColor);
      canvas.drawRect(cropView.left + cropView.width() * 0.66f - 2, cropView.top, cropView.left + cropView.width() * 0.66f + 2, cropView.bottom, mainColor);
    }
    if (rect != null) {

      canvas.drawRect(rect, mainColor);
    }
    if (zoomListener != null && getDrawable() != null) {
      if (oldScale != getCurrentZoom()) {
        zoomListener.onZoomChangeScale(getCurrentZoom());
        oldScale = getCurrentZoom();
      } else {
        zoomListener.onScroll(getZoomedRect());
      }
    }
  }

  public void setOldScale(float oldScale) {
    this.oldScale = oldScale;
    invalidate();
  }

  public interface ZoomListener {
    void onZoomChangeScale(float zoomScale);

    void onScroll(RectF rectF);
  }
}
