package com.mazadatimagepicker.Camera.CustomViews;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.AppCompatImageView;

import com.mazadatimagepicker.R;

public class ImageCropper extends AppCompatImageView {

  Paint black_layer;
  Paint mainColor;
  Paint red;
  RectF cropView;
  float aspectRatioX = 4.0f;
  float aspectRatioY = 3.0f;
  float width, height;
  float x, y;
  boolean once = true;
  float start_x;
  float start_y;
  int area = 0;
  int offset = 80;
  float old_x;
  float old_y;
  float old_width;
  float old_height;
  float min_width;
  float dp;
  float offset_height;
  float offset_width;
  Bitmap bm;
  RectF matrix = new RectF();
  Boolean getDimensionsOnce = true;
  int frame_width, frame_height;

  public ImageCropper(Context context) {
    super(context);
    init();
  }

  public ImageCropper(@NonNull Context context, @Nullable AttributeSet attrs) {
    super(context, attrs);
    init();
  }

  public void init() {
    dp = getResources().getDisplayMetrics().density;
    min_width = 100 * dp;

    black_layer = new Paint();
    black_layer.setAntiAlias(true);
    black_layer.setColor(Color.parseColor("#80000000"));

    mainColor = new Paint();
    mainColor.setAntiAlias(true);
    mainColor.setColor(getResources().getColor(R.color.turquoise_blue));

    red = new Paint();
    red.setAntiAlias(true);
    red.setColor(Color.parseColor("#ff0000"));

  }

  public Bitmap crop() {
    bm = ((BitmapDrawable) getDrawable()).getBitmap();
    bm = Bitmap.createScaledBitmap(bm, getWidth(), getHeight(), true);
    return Bitmap.createBitmap(bm, (int) (cropView.left), (int) (cropView.top), (int) cropView.width(), (int) cropView.height());
  }

  @Override
  public void setImageURI(@Nullable Uri uri) {
    super.setImageURI(uri);
    if (frame_width > 0) {
      ViewGroup.LayoutParams params = getLayoutParams();
      params.height = frame_height;
      params.width = frame_width;
      setLayoutParams(params);
    }

    once = true;
    invalidate();
  }


  @Override
  protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    if (getDrawable() != null) {
      if (getDimensionsOnce) {
        frame_width = getWidth();
        frame_height = getHeight();
        getDimensionsOnce = false;
      }
      if (once) {
        once = false;

        getImageMatrix().mapRect(matrix, new RectF(getDrawable().getBounds()));
        int new_width = (int) matrix.width();
        int new_height = (int) matrix.height();

        ViewGroup.LayoutParams params = getLayoutParams();
        params.height = new_height;
        params.width = new_width;
        setLayoutParams(params);

        if (new_height > new_width) {
          width = new_width * 0.7f;
          height = width * aspectRatioY / aspectRatioX;
        } else {
          height = new_height * 0.7f;
          width = height * aspectRatioX / aspectRatioY;
        }
        x = new_width * 0.1f;
        y = new_height / 2f - height / 2f;

        bm = ((BitmapDrawable) getDrawable()).getBitmap();


      }
      cropView = new RectF(x, y, x + width, y + height);

      canvas.drawRect(0, 0, getWidth(), cropView.top, black_layer);
      canvas.drawRect(0, cropView.bottom, getWidth(), getHeight(), black_layer);
      canvas.drawRect(0, cropView.top, cropView.left, cropView.bottom, black_layer);
      canvas.drawRect(cropView.right, cropView.top, getWidth(), cropView.bottom, black_layer);

      //green frame corners
      canvas.drawCircle(cropView.left, cropView.top, 20, mainColor);
      canvas.drawCircle(cropView.right, cropView.top, 20, mainColor);
      canvas.drawCircle(cropView.left, cropView.bottom, 20, mainColor);
      canvas.drawCircle(cropView.right, cropView.bottom, 20, mainColor);

      //green frame sides
      canvas.drawRect(cropView.left, cropView.top - 4, cropView.right, cropView.top + 4, mainColor);
      canvas.drawRect(cropView.left, cropView.bottom - 4, cropView.right, cropView.bottom + 4, mainColor);
      canvas.drawRect(cropView.left - 4, cropView.top, cropView.left + 4, cropView.bottom, mainColor);
      canvas.drawRect(cropView.right - 4, cropView.top, cropView.right + 4, cropView.bottom, mainColor);

      //green draw grid
      canvas.drawRect(cropView.left, cropView.top + cropView.height() * 0.33f - 2, cropView.right, cropView.top + cropView.height() * 0.33f + 2, mainColor);
      canvas.drawRect(cropView.left, cropView.top + cropView.height() * 0.66f - 2, cropView.right, cropView.top + cropView.height() * 0.66f + 2, mainColor);
      canvas.drawRect(cropView.left + cropView.width() * 0.33f - 2, cropView.top, cropView.left + cropView.width() * 0.33f + 2, cropView.bottom, mainColor);
      canvas.drawRect(cropView.left + cropView.width() * 0.66f - 2, cropView.top, cropView.left + cropView.width() * 0.66f + 2, cropView.bottom, mainColor);
    }

  }

  @Override
  public boolean onTouchEvent(MotionEvent event) {
    float raw_x = event.getX();
    float raw_y = event.getY();
    switch (event.getAction()) {
      case MotionEvent.ACTION_DOWN:
        start_x = raw_x;
        start_y = raw_y;
        if (new RectF(cropView.left - offset, cropView.top - offset, cropView.left + offset, cropView.top + offset).contains(start_x, start_y)) {
          area = 1;
        } else if (new RectF(cropView.right - offset, cropView.top - offset, cropView.right + offset, cropView.top + offset).contains(start_x, start_y)) {
          area = 2;
        } else if (new RectF(cropView.left - offset, cropView.bottom - offset, cropView.left + offset, cropView.bottom + offset).contains(start_x, start_y)) {
          area = 3;
        } else if (new RectF(cropView.right - offset, cropView.bottom - offset, cropView.right + offset, cropView.bottom + offset).contains(start_x, start_y)) {
          area = 4;
        } else if (new RectF(cropView.left + offset, cropView.top - offset, cropView.right - offset, cropView.top + offset).contains(start_x, start_y)) {
          area = 5;
        } else if (new RectF(cropView.right - offset, cropView.top + offset, cropView.right + offset, cropView.bottom - offset).contains(start_x, start_y)) {
          area = 6;
        } else if (new RectF(cropView.left + offset, cropView.bottom - offset, cropView.right - offset, cropView.bottom + offset).contains(start_x, start_y)) {
          area = 7;
        } else if (new RectF(cropView.left - offset, cropView.top + offset, cropView.left + offset, cropView.bottom - offset).contains(start_x, start_y)) {
          area = 8;
        } else if (new RectF(cropView.left + offset, cropView.top + offset, cropView.right - offset, cropView.bottom - offset).contains(start_x, start_y)) {
          area = 9;
          offset_height = cropView.bottom - start_y;
          offset_width = cropView.right - start_x;
        }
        old_x = x;
        old_y = y;
        old_width = cropView.width();
        old_height = cropView.height();
        break;
      case MotionEvent.ACTION_MOVE:
        float diff_x = raw_x - start_x;
        float diff_y = raw_y - start_y;
        if (area == 1 && old_width - diff_x > min_width
          && old_height - diff_y > min_width &&
          (old_y + diff_y) > 0 &&
          old_x + diff_x > 0) {
          x = old_x + diff_x;
          y = old_y + diff_y;
          width = old_width - diff_x;
          height = old_height - diff_y;
          invalidate();
        } else if (area == 2 && old_width + diff_x > min_width &&
          old_height - diff_y > min_width &&
          old_y + diff_y  > 0
          && cropView.left + old_width + diff_x < getWidth()) {
          y = old_y + diff_y;
          width = old_width + diff_x;
          height = old_height - diff_y;
          invalidate();
        } else if (area == 3 && old_width - diff_x > min_width &&
          old_height + diff_y > min_width &&
          (cropView.top + old_height + diff_y ) < getHeight() &&
          old_x + diff_x > 0) {
          x = old_x + diff_x;
          width = old_width - diff_x;
          height = old_height + diff_y;
          invalidate();
        } else if (area == 4 && old_width + diff_x > min_width &&
          old_height + diff_y > min_width &&
          (cropView.top + old_height + diff_y) < getHeight() &&
          cropView.left + old_width + diff_x < getWidth()) {
          width = old_width + diff_x;
          height = old_height + diff_y;
          invalidate();
        } else if (area == 5 && old_height - diff_y > min_width &&
          (old_y + diff_y) > 0) {
          y = old_y + diff_y;
          height = old_height - diff_y;
          invalidate();
        } else if (area == 6 &&
          (old_width + diff_x) > min_width &&
          (diff_x + old_x + old_width < getWidth())) {
          width = old_width + diff_x;

          invalidate();
        } else if (area == 7 &&
          (old_height + diff_y) > min_width &&
          (old_y + old_height + diff_y) < getHeight()) {

          height = old_height + diff_y;
          invalidate();
        } else if (area == 8 && old_width - diff_x > min_width &&
          (old_x + diff_x) > 0 &&
          (old_width - diff_x) > min_width) {

          x = old_x + diff_x;
          width = old_width - diff_x;

          invalidate();
        } else if (area == 9) {
          if (old_x + diff_x > 0 && offset_width + raw_x < getWidth()) {
            x = old_x + diff_x;
          }
          if (old_y + diff_y > 0 && offset_height + raw_y < getHeight()) {
            y = old_y + diff_y;
          }
          invalidate();
        }
        break;
      case MotionEvent.ACTION_UP:
      case MotionEvent.ACTION_CANCEL:
        area = 0;
        break;
    }

    return true;
  }
}
