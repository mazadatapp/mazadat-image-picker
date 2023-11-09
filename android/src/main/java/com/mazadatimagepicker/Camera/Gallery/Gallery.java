package com.mazadatimagepicker.Camera.Gallery;

import android.content.ClipData;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.exifinterface.media.ExifInterface;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.mazadatimagepicker.Camera.CustomViews.ImageCropper;
import com.mazadatimagepicker.Camera.Utils.FileUtils;
import com.mazadatimagepicker.Camera.Utils.ImageUtils;
import com.mazadatimagepicker.R;

import java.io.File;
import java.util.ArrayList;
import java.util.LinkedList;

public class Gallery extends AppCompatActivity {
  final int SELECT_PICTURE = 20;
  FileUtils fileUtils;
  ImageCropper imageCropper;
  RecyclerView galleryRecycler;
  ImageView cropIm;
  Button doneBtn;

  LinkedList<GalleryItemModel> galleryItemModels = new LinkedList<>();
  GalleryImageItemsAdapter adapter;
  private int maxNumberOfImages;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_gallery);
    imageCropper = findViewById(R.id.image_cropper);
    galleryRecycler = findViewById(R.id.recycler);
    maxNumberOfImages = getIntent().getIntExtra("maxImagesNumber",1);
    cropIm = findViewById(R.id.cropIm);
    doneBtn = findViewById(R.id.done_btn);
    fileUtils = new FileUtils(this);

    adapter = new GalleryImageItemsAdapter(this, galleryItemModels);
    galleryRecycler.setLayoutManager(new LinearLayoutManager(this, RecyclerView.HORIZONTAL, false));
    galleryRecycler.setAdapter(adapter);

    Intent chooseIntent = new Intent();
    chooseIntent.setType("image/*");
    chooseIntent.setAction(Intent.ACTION_GET_CONTENT);
    chooseIntent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, maxNumberOfImages>1);
    startActivityForResult(Intent.createChooser(chooseIntent, "Select Picture"), SELECT_PICTURE);

    cropIm.setOnClickListener(view -> cropImagePressed());
    doneBtn.setOnClickListener(view -> donePressed());
  }

  private void donePressed() {
    boolean allCropped = true;
    for (int i = 0; i < galleryItemModels.size(); i++) {
      if (!galleryItemModels.get(i).isCropped()) {
        allCropped = false;
      }
    }
    if (allCropped) {
      ArrayList<String> paths = new ArrayList<>();
      for (int i = 0; i < galleryItemModels.size(); i++) {
        paths.add(galleryItemModels.get(i).getCroppedFile().getPath());
      }
      Intent intent = new Intent();
      intent.putStringArrayListExtra("paths", paths);
      setResult(RESULT_OK, intent);
      finish();
    } else {
      Toast.makeText(this, getString(R.string.please_crop_all_the_images), Toast.LENGTH_SHORT).show();
    }
  }

  private void cropImagePressed() {
    if (imageCropper.getCropView() != null) {
      galleryItemModels.get(adapter.selectedPosition).setCropView(imageCropper.getCropView());
      galleryItemModels.get(adapter.selectedPosition).setCropped(true);

      Bitmap croppedBitmap = imageCropper.crop();
      croppedBitmap = ImageUtils.createBitmap(imageCropper.getWidth(), (int) (imageCropper.getWidth() * 3f / 4f), croppedBitmap);
      File file = ImageUtils.bitmapToFile(this, croppedBitmap);
      galleryItemModels.get(adapter.selectedPosition).setCroppedFile(file);
      adapter.notifyItemChanged(adapter.selectedPosition);

      if (galleryItemModels.size() == 1) {
        Intent intent = new Intent();
        ArrayList<String> paths = new ArrayList<>();
        paths.add(file.getPath());
        intent.putStringArrayListExtra("paths", paths);
        setResult(RESULT_OK, intent);
        finish();
      }else if(adapter.selectedPosition<galleryItemModels.size()-1 && !galleryItemModels.get(adapter.selectedPosition+1).isCropped()){
        switchImage(adapter.selectedPosition + 1);
      }

    }
  }

  public void updateImageCropper(GalleryItemModel galleryItemModel) {
    if (galleryItemModel.getCropView() != null) {
      imageCropper.setCropView(galleryItemModel.getCropView());
    }
    imageCropper.setImageBitmap(galleryItemModel.getBitmap());
  }

  public void switchImage(int position) {
    galleryItemModels.get(adapter.selectedPosition).setCropView(imageCropper.getCropView());
    adapter.selectedPosition = position;
    updateImageCropper(galleryItemModels.get(position));
    adapter.notifyDataSetChanged();
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (resultCode == RESULT_OK && requestCode == SELECT_PICTURE) {
      if (data.getClipData() != null) {
        ClipData mClipData = data.getClipData();

        int max = Math.min(mClipData.getItemCount(), maxNumberOfImages);
        if (mClipData.getItemCount() > maxNumberOfImages) {
          Toast.makeText(this, getString(R.string.max_images_are)+" "+maxNumberOfImages, Toast.LENGTH_SHORT).show();
        }
        for (int i = 0; i < max; i++) {
          ClipData.Item item = mClipData.getItemAt(i);
          GalleryItemModel model = uriToGalleryModel(item.getUri());
          if (model != null) {
            galleryItemModels.addLast(model);
          }
        }
        if (galleryItemModels.size() > 1) {
          galleryRecycler.setVisibility(View.VISIBLE);
          imageCropper.setImageBitmap(galleryItemModels.getFirst().getBitmap());
          adapter.notifyDataSetChanged();
        } else if (galleryItemModels.size() == 1) {
          galleryRecycler.setVisibility(View.GONE);
          doneBtn.setVisibility(View.GONE);
          imageCropper.setImageBitmap(galleryItemModels.getFirst().getBitmap());
        } else {
          Toast.makeText(this, getString(R.string.cannot_fetch_image), Toast.LENGTH_SHORT).show();
          finish();
        }
      } else if (data.getData() != null) {
        Uri imageUri = data.getData();
        GalleryItemModel model = uriToGalleryModel(imageUri);
        galleryItemModels.addLast(model);
        if (model == null) {
          Toast.makeText(this, getString(R.string.cannot_fetch_image), Toast.LENGTH_SHORT).show();
          finish();
        } else {
          galleryRecycler.setVisibility(View.GONE);
          doneBtn.setVisibility(View.GONE);
          imageCropper.setImageBitmap(model.getBitmap());
        }
      }

    } else {
      finish();
    }
  }

  private GalleryItemModel uriToGalleryModel(Uri selectedImageUri) {
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
      return new GalleryItemModel(bitmap);
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }
  }
}
