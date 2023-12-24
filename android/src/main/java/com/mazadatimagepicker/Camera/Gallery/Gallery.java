package com.mazadatimagepicker.Camera.Gallery;

import android.app.Activity;
import android.content.ClipData;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import androidx.exifinterface.media.ExifInterface;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.budiyev.android.circularprogressbar.CircularProgressBar;
import com.mazadatimagepicker.Camera.CustomViews.ImageCropper;
import com.mazadatimagepicker.Camera.Utils.FileUtils;
import com.mazadatimagepicker.Camera.Utils.ImageUtils;
import com.mazadatimagepicker.R;

import java.io.BufferedOutputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.LinkedList;

public class Gallery extends Activity {
  final int SELECT_PICTURE = 20;
  FileUtils fileUtils;
  CircularProgressBar progress;
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
    progress = findViewById(R.id.progress);
    galleryRecycler = findViewById(R.id.recycler);
    maxNumberOfImages = getIntent().getIntExtra("maxImagesNumber", 1);
    cropIm = findViewById(R.id.cropIm);
    doneBtn = findViewById(R.id.done_btn);
    fileUtils = new FileUtils(this);

    adapter = new GalleryImageItemsAdapter(this, galleryItemModels);
    galleryRecycler.setLayoutManager(new LinearLayoutManager(this, RecyclerView.HORIZONTAL, false));
    galleryRecycler.setAdapter(adapter);

    Intent chooseIntent = new Intent();
    chooseIntent.setType("image/*");
    chooseIntent.setAction(Intent.ACTION_GET_CONTENT);
    chooseIntent.putExtra(Intent.EXTRA_ALLOW_MULTIPLE, maxNumberOfImages > 1);
    startActivityForResult(Intent.createChooser(chooseIntent, "Select Picture"), SELECT_PICTURE);

    cropIm.setOnClickListener(view -> cropImagePressed());
    doneBtn.setOnClickListener(view -> donePressed());

    progress.setIndeterminate(true);

  }

  private void donePressed() {
    doneBtn.setVisibility(View.GONE);
    progress.setVisibility(View.VISIBLE);
    AsyncTask.execute(() -> {
      ArrayList<String> paths = new ArrayList<>();
      ArrayList<Integer> perentages = new ArrayList<>();
      for (int i = 0; i < galleryItemModels.size(); i++) {
        if (galleryItemModels.get(i).isCropped()) {
          paths.add(galleryItemModels.get(i).getCroppedFile().getPath());
        } else {
          int width = galleryItemModels.get(i).getBitmap().getWidth();
          Bitmap fullBitmap = ImageUtils.createBitmap(width, (int) (width * 3f / 4f), galleryItemModels.get(i).getBitmap());
          File file = ImageUtils.bitmapToFile(this, fullBitmap,galleryItemModels.get(i).getPercentage());
          paths.add(file.getPath());
          perentages.add(galleryItemModels.get(i).getPercentage());
        }
      }
      Intent intent = new Intent();
      intent.putStringArrayListExtra("paths", paths);
      intent.putIntegerArrayListExtra("percentages", perentages);
      setResult(RESULT_OK, intent);
      finish();
    });

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
      } else if (adapter.selectedPosition < galleryItemModels.size() - 1 && !galleryItemModels.get(adapter.selectedPosition + 1).isCropped()) {
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
      progress.setVisibility(View.VISIBLE);
      AsyncTask.execute(() -> {
        if (data.getClipData() != null) {
          ClipData mClipData = data.getClipData();


          for (int i = 0; i < mClipData.getItemCount(); i++) {
            ClipData.Item item = mClipData.getItemAt(i);
            GalleryItemModel model = uriToGalleryModel(item.getUri());
            if (model != null) {
              galleryItemModels.addLast(model);
            }
          }

          if (galleryItemModels.size() > maxNumberOfImages) {
            runOnUiThread(() -> {
              Toast.makeText(this, getString(R.string.max_images_are) + " " + maxNumberOfImages, Toast.LENGTH_SHORT).show();
            });
            int diff = galleryItemModels.size() - maxNumberOfImages;
            for (int i = 0; i < diff; i++) {
              galleryItemModels.removeLast();
            }
          }
          runOnUiThread(() -> {
            if (galleryItemModels.size() > 0) {
//              galleryRecycler.setVisibility(View.VISIBLE);
//              imageCropper.setImageBitmap(galleryItemModels.getFirst().getBitmap());
//              adapter.notifyDataSetChanged();
//            } else if (galleryItemModels.size() == 1) {
//              galleryRecycler.setVisibility(View.GONE);
//              doneBtn.setVisibility(View.GONE);
//              imageCropper.setImageBitmap(galleryItemModels.getFirst().getBitmap());
              donePressed();
            } else {
              Toast.makeText(this, getString(R.string.cannot_fetch_image), Toast.LENGTH_SHORT).show();
              finish();
            }
//            processingCl.setVisibility(View.GONE);
          });

        } else if (data.getData() != null) {
          Uri imageUri = data.getData();
          GalleryItemModel model = uriToGalleryModel(imageUri);
          galleryItemModels.addLast(model);
          runOnUiThread(() -> {
            if (model == null) {
              Toast.makeText(this, getString(R.string.cannot_fetch_image), Toast.LENGTH_SHORT).show();
              finish();
            } else {
              donePressed();
//              galleryRecycler.setVisibility(View.GONE);
//              doneBtn.setVisibility(View.GONE);
//              imageCropper.setImageBitmap(model.getBitmap());
            }
            //processingCl.setVisibility(View.GONE);
          });

        }
      });
    } else {
      finish();
    }
  }

  private GalleryItemModel uriToGalleryModel(Uri selectedImageUri) {
    try {
      File temp = createTmpFileFromUri(selectedImageUri, "test.png");
      Bitmap bitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), selectedImageUri);
      String path = fileUtils.getPath(selectedImageUri);
      int percentage=100;
      //Log.i("datadata", bitmap.getWidth() + " " + bitmap.getHeight() + " " + temp.length() + "");
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
      if (temp.length() > 4000000) {
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        percentage = (int)((4000000.0/temp.length())*100);
        bitmap.compress(Bitmap.CompressFormat.JPEG, percentage, out);
        bitmap = BitmapFactory.decodeStream(new ByteArrayInputStream(out.toByteArray()));
       // Log.i("datadata", bitmap.getWidth() + " " + bitmap.getHeight()+" "+out.toByteArray().length);
      }
      if (rotation != 0) {
        bitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
      }
      return new GalleryItemModel(bitmap,percentage);
    } catch (Exception e) {
      e.printStackTrace();
      return null;
    }


  }

  private File createTmpFileFromUri(Uri uri, String fileName) {
    File file = null;
    try {
      InputStream stream = getContentResolver().openInputStream(uri);
      file = File.createTempFile(fileName, "", getCacheDir());
      org.apache.commons.io.FileUtils.copyInputStreamToFile(stream, file);
    } catch (Exception e) {
      e.printStackTrace();
    }
    return file;
  }

}
