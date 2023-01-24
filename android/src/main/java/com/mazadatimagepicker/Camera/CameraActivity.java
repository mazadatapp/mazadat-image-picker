package com.mazadatimagepicker.Camera;


import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.mazadatimagepicker.Camera.CustomViews.ImageCropper;
import com.mazadatimagepicker.Camera.CustomViews.RectangleHole;
import com.mazadatimagepicker.Camera.Gallery.Gallery;
import com.mazadatimagepicker.Camera.Image.ImageItem;
import com.mazadatimagepicker.Camera.Image.ImageItemsAdapter;
import com.mazadatimagepicker.Camera.Utils.ImageUtils;
import com.mazadatimagepicker.R;
import com.otaliastudios.cameraview.CameraListener;
import com.otaliastudios.cameraview.CameraView;
import com.otaliastudios.cameraview.PictureResult;
import com.otaliastudios.cameraview.controls.Flash;

import java.io.File;
import java.util.LinkedList;

public class CameraActivity extends AppCompatActivity {

  final int GALLERY_REQUEST_CODE = 10;

  CameraView cameraView;
  ImageView captureIm;
  ImageView flashIm;

  //edit views
  ConstraintLayout editCl;
  ImageView image;
  ImageCropper imageCropper;
  Button cropBtn;
  Button rotateBtn;
  Button deleteBtn;

  ImageView confirmIm;
  ImageView declineIm;

  Button galleryBtn;
  ImageView closeIm;

  RectangleHole rectangleHole;

  TextView maxImagesTv;

  RecyclerView recycler;
  ImageItemsAdapter adapter;
  LinkedList<ImageItem> imageItems;

  int maxImagesSize;
  int imageTurn = 0;
  int selectedEditIndex = -1;
  int editType = 0;

  boolean flashIsOn = false;
  boolean isEditModeOn = false;

  Drawable cropBlue;
  Drawable cropWhite;
  Drawable rotateBlue;
  Drawable rotateWhite;

  int rotationAngle = 0;

  Bitmap originalBitmap;
  Bitmap rotationBitmap;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_camera);
    cameraView = findViewById(R.id.camera);
    captureIm = findViewById(R.id.capture_im);
    flashIm = findViewById(R.id.flash_im);
    recycler = findViewById(R.id.recycler);
    rectangleHole = findViewById(R.id.rectangle_hole);
    maxImagesTv = findViewById(R.id.max_images_tv);
    galleryBtn = findViewById(R.id.gallery_btn);
    closeIm = findViewById(R.id.close_im);

    //edit views
    editCl = findViewById(R.id.edit_cl);
    imageCropper = findViewById(R.id.image_cropper);
    image = findViewById(R.id.image);
    cropBtn = findViewById(R.id.crop_btn);
    rotateBtn = findViewById(R.id.rotate_btn);
    deleteBtn = findViewById(R.id.delete_btn);

    confirmIm = findViewById(R.id.confirm_im);
    declineIm = findViewById(R.id.decline_im);

    cropBlue = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_crop_blue, getTheme());
    cropWhite = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_crop, getTheme());
    rotateBlue = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_rotate_blue, getTheme());
    rotateWhite = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_rotate, getTheme());

    cameraHandler();

    maxImagesSize = getIntent().getIntExtra("maxImagesSize", 0);

    maxImagesTv.setText(String.format("%s %s", getString(R.string.max_number_selected_images_is), maxImagesSize));

    imageItems = new LinkedList<>();
    imageItems.addLast(new ImageItem());

    adapter = new ImageItemsAdapter(this, imageItems);
    recycler.setLayoutManager(new LinearLayoutManager(this, RecyclerView.HORIZONTAL, false));
    recycler.setAdapter(adapter);

    captureIm.setOnClickListener(view -> capturePressed());
    flashIm.setOnClickListener(view -> flashPressed());
    galleryBtn.setOnClickListener(view -> openGallery());
    closeIm.setOnClickListener(view -> openClosConfirmationDialog());

    //edit views
    cropBtn.setOnClickListener(view -> cropPressed());
    rotateBtn.setOnClickListener(view -> rotatePressed());
    deleteBtn.setOnClickListener(view -> deletePressed());
    confirmIm.setOnClickListener(view -> confirmPressed());
    declineIm.setOnClickListener(view -> resetPressed());

  }

  private void openGallery() {
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
      startActivityForResult(new Intent(this, Gallery.class), GALLERY_REQUEST_CODE);
    } else {
      int READ_WRITE_REQUEST_PERMISSION = 20;
      ActivityCompat.requestPermissions(this,
        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE},
        READ_WRITE_REQUEST_PERMISSION);
    }

  }

  private void openClosConfirmationDialog() {
  }

  private void capturePressed() {
    cameraView.takePicture();
  }

  private void flashPressed() {
    flashIsOn = !flashIsOn;
    flashIm.setImageResource(flashIsOn ? R.drawable.ic_flash_off : R.drawable.ic_flash_on);
    cameraView.setFlash(flashIsOn ? Flash.ON : Flash.OFF);
  }

  @Override
  protected void onResume() {
    super.onResume();
    cameraView.open();
  }

  @Override
  protected void onStop() {
    super.onStop();
    cameraView.close();
  }

  private void cameraHandler() {
    cameraView.addCameraListener(new CameraListener() {
      @Override
      public void onPictureTaken(@NonNull PictureResult result) {
        super.onPictureTaken(result);
        result.toBitmap(rectangleHole.getWidth(), rectangleHole.getHeight(), bitmap -> {
          assert bitmap != null;

          Bitmap scaledBitmap = Bitmap.createScaledBitmap(bitmap, rectangleHole.getWidth(), rectangleHole.getHeight(), true);
          Bitmap croppedBitmap = Bitmap.createBitmap(scaledBitmap, (int) rectangleHole.getFocusArea().left, (int) rectangleHole.getFocusArea().top, (int) rectangleHole.getFocusArea().width(), (int) rectangleHole.getFocusArea().height());

          File file = ImageUtils.bitmapToFile(CameraActivity.this, croppedBitmap);
          addImageToList(file);
        });

      }
    });
  }

  private void addImageToList(File file) {

    imageItems.get(imageTurn).setFile(file);
    adapter.notifyItemChanged(imageTurn);
    recycler.smoothScrollToPosition(imageTurn);

    imageTurn++;
    imageItems.addLast(new ImageItem());
  }

  public void editOrCapturePhoto(int position) {
    if (imageItems.get(position).getFile() != null && !isEditModeOn) {

      selectedEditIndex = position;

      editCl.setVisibility(View.VISIBLE);
      confirmIm.setVisibility(View.VISIBLE);
      declineIm.setVisibility(View.VISIBLE);
      captureIm.setVisibility(View.GONE);
      cameraView.close();
      cameraView.stopVideo();

      image.setImageURI(Uri.fromFile(imageItems.get(position).getFile()));
      isEditModeOn = true;

      cropBtn.setAlpha(1.0f);
      rotateBtn.setAlpha(1.0f);
      deleteBtn.setAlpha(1.0f);
    } else if (imageItems.get(position).getFile() == null && isEditModeOn) {
      editCl.setVisibility(View.GONE);
      confirmIm.setVisibility(View.GONE);
      declineIm.setVisibility(View.GONE);
      captureIm.setVisibility(View.VISIBLE);
      cameraView.open();

      cropBtn.setAlpha(0.38f);
      rotateBtn.setAlpha(0.38f);
      deleteBtn.setAlpha(0.38f);

      isEditModeOn = false;
    }
  }

  private void cropPressed() {
    if (isEditModeOn && editType == 0) {
      editType = 1;
      cropBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, cropBlue, null, null);
      imageCropper.setVisibility(View.VISIBLE);
      imageCropper.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
    }
  }

  private void rotatePressed() {
    if (isEditModeOn && editType == 0) {
      editType = 2;
      rotateBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, rotateBlue, null, null);
      originalBitmap = BitmapFactory.decodeFile(imageItems.get(selectedEditIndex).getFile().getPath());
      rotateImageBy(-90);
    }else if (isEditModeOn && editType == 2) {
      rotateImageBy(-90);
    }
  }

  private void rotateImageBy(int angle){
    rotationAngle += angle;
    rotationBitmap = ImageUtils.rotateBitmap(originalBitmap,rotationAngle);
    rotationBitmap = ImageUtils.createBitmap(image.getWidth(),image.getHeight(),rotationBitmap);
    image.setImageBitmap(rotationBitmap);
  }

  private void deletePressed() {

  }

  private void confirmPressed() {
    if (editType == 1) {
      Bitmap croppedBitmap = imageCropper.crop();
      File file = ImageUtils.bitmapToFile(this, croppedBitmap);
      imageItems.get(selectedEditIndex).setFile(file);
      adapter.notifyItemChanged(selectedEditIndex);
    }else if(editType == 2){
      File file = ImageUtils.bitmapToFile(this, rotationBitmap);
      imageItems.get(selectedEditIndex).setFile(file);
      adapter.notifyItemChanged(selectedEditIndex);
    }

    image.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
    resetPressed();
  }

  private void resetPressed() {
    imageCropper.setVisibility(View.GONE);
    cropBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, cropWhite, null, null);
    rotateBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, rotateWhite, null, null);
    editType = 0;
  }


  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (resultCode == RESULT_OK && requestCode == GALLERY_REQUEST_CODE) {
      String path = data.getStringExtra("path");
      addImageToList(new File(path));
    }
  }
}
