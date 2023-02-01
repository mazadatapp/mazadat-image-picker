package com.mazadatimagepicker.Camera.CustomViews;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.PorterDuff;
import android.graphics.PorterDuffXfermode;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.ViewGroup;

import com.mazadatimagepicker.R;

public class RectangleHole extends ViewGroup {

  float dp;
  int aspectRatioX = 4;
  int aspectRatioY = 3;
  RectF focusArea;
  Paint blue;

  public RectangleHole(Context context) {
    super(context);
    init(context);
  }

  public RectangleHole(Context context, AttributeSet attrs) {
    this(context, attrs, 0);
    init(context);
  }

  public RectangleHole(Context context, AttributeSet attrs, int defStyle) {
    super(context, attrs, defStyle);
    init(context);
  }

  public void init(Context context) {
    dp = context.getResources().getDisplayMetrics().density;
    blue = new Paint();
    blue.setColor(getResources().getColor(R.color.turquoise_blue));
    blue.setStrokeWidth(3 * dp);
  }

  @Override
  protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    setMeasuredDimension(widthMeasureSpec, heightMeasureSpec);
  }

  @Override
  public void onLayout(boolean changed, int left, int top, int right, int bottom) {
  }

  @Override
  public boolean shouldDelayChildPressedState() {
    return false;
  }

  @Override
  protected void dispatchDraw(Canvas canvas) {
    super.dispatchDraw(canvas);
    float width = getWidth() * 0.91f;
    float height = width * aspectRatioY / aspectRatioX;
    if (focusArea == null) {
      focusArea = new RectF(getWidth() / 2f - width / 2f, getHeight() * 0.2f, getWidth() / 2f + width / 2, getHeight() * 0.2f + height);
    }
    Paint black = new Paint();
    black.setColor(getContext().getResources().getColor(R.color.black_70));
    canvas.drawRect(0, 0, getWidth(), getHeight(), black);

    Paint eraser = new Paint();
    eraser.setAntiAlias(true);
    eraser.setXfermode(new PorterDuffXfermode(PorterDuff.Mode.CLEAR));

    canvas.drawRect(getWidth() / 2f - width / 2f - 2 * dp, getHeight() * 0.2f - 2 * dp, getWidth() / 2f - width / 2f + 30 * dp, getHeight() * 0.2f + 30 * dp, blue);
    canvas.drawRect(getWidth() / 2f + width / 2f - 30 * dp, getHeight() * 0.2f - 2 * dp, getWidth() / 2f + width / 2f + 2 * dp, getHeight() * 0.2f + 30 * dp, blue);

    canvas.drawRect(getWidth() / 2f - width / 2f - 2 * dp, getHeight() * 0.2f + height - 30 * dp, getWidth() / 2f - width / 2f + 30 * dp, getHeight() * 0.2f + height + 2 * dp, blue);
    canvas.drawRect(getWidth() / 2f + width / 2f - 30 * dp, getHeight() * 0.2f + height - 32 * dp, getWidth() / 2f + width / 2f + 2 * dp, getHeight() * 0.2f + height + 2 * dp, blue);

    canvas.drawRect(focusArea, eraser);


  }

  public int getAspectRatioX() {
    return aspectRatioX;
  }

  public int getAspectRatioY() {
    return aspectRatioY;
  }
}
