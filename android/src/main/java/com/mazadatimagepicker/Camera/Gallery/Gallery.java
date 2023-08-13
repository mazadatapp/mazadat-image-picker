package com.mazadatimagepicker.Camera.Gallery;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.widget.ImageView;

import androidx.appcompat.app.AppCompatActivity;

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
    Bitmap croppedBitmap = imageCropper.crop();
    croppedBitmap = ImageUtils.createBitmap(imageCropper.getWidth(), (int)(imageCropper.getWidth() * 3f / 4f), croppedBitmap);
    File file = ImageUtils.bitmapToFile(this, croppedBitmap);
    Intent intent = new Intent();
    intent.putExtra("path", file.getPath());
    setResult(RESULT_OK, intent);
    finish();
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (resultCode == RESULT_OK && requestCode == SELECT_PICTURE) {
      Uri selectedImageUri = data.getData();
      String path = fileUtils.getPath(selectedImageUri);
      imageCropper.setImageURI(Uri.fromFile(new File(path)));
    } else {
      finish();
    }
  }
}
