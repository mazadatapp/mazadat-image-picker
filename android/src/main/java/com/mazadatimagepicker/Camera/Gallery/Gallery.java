package com.mazadatimagepicker.Camera.Gallery;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.exifinterface.media.ExifInterface;

import com.mazadatimagepicker.Camera.CustomViews.ImageCropper;
import com.mazadatimagepicker.Camera.Utils.FileUtils;
import com.mazadatimagepicker.Camera.Utils.ImageUtils;
import com.mazadatimagepicker.R;

import java.io.File;

public class Gallery extends AppCompatActivity {
  final int SELECT_PICTURE = 20;
  FileUtils fileUtils;
  ImageCropper imageCropper;
  ImageView cropIm;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_gallery);
    imageCropper = findViewById(R.id.image_cropper);
    cropIm = findViewById(R.id.cropIm);
    fileUtils = new FileUtils(this);

    Intent i = new Intent();
    i.setType("image/*");
    i.setAction(Intent.ACTION_GET_CONTENT);

    startActivityForResult(Intent.createChooser(i, "Select Picture"), SELECT_PICTURE);

    cropIm.setOnClickListener(view -> cropImagePressed());
  }

  private void cropImagePressed() {
    if (imageCropper.getCropView() != null) {
      Bitmap croppedBitmap = imageCropper.crop();
      croppedBitmap = ImageUtils.createBitmap(imageCropper.getWidth(), (int) (imageCropper.getWidth() * 3f / 4f), croppedBitmap);
      File file = ImageUtils.bitmapToFile(this, croppedBitmap);
      Intent intent = new Intent();
      intent.putExtra("path", file.getPath());
      setResult(RESULT_OK, intent);
      finish();
    }
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (resultCode == RESULT_OK && requestCode == SELECT_PICTURE) {
      Uri selectedImageUri = data.getData();
      try {
        Bitmap bitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), selectedImageUri);
        String path = fileUtils.getPath(selectedImageUri);
        Matrix matrix = new Matrix();
        int rotation = 0;
        try {
          if (path != null) {
            ExifInterface exif = new ExifInterface(path);
            rotation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
            ImageUtils.getRotation(rotation, matrix);
          }
        } catch (Exception e) {
          e.printStackTrace();
        }
        if (bitmap.getWidth() * bitmap.getHeight() > 23040000) {
          float scale;
          if (bitmap.getWidth() > bitmap.getHeight()) {
            scale = 4800.0f / (float) bitmap.getWidth();
          } else {
            scale = 4800.0f / (float) bitmap.getHeight();
          }
          matrix.postScale(scale, scale);
          bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        } else if (rotation != 0) {
          bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        }
        imageCropper.setImageBitmap(bitmap);
      } catch (Exception e) {
        e.printStackTrace();
        Toast.makeText(this, getString(R.string.cannot_fetch_image), Toast.LENGTH_SHORT).show();
        finish();
      }
    } else {
      finish();
    }
  }
}
