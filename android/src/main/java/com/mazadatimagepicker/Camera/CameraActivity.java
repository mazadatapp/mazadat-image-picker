package com.mazadatimagepicker.Camera;


import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
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

import com.mazadatimagepicker.BuildConfig;
import com.mazadatimagepicker.Camera.CloseDialog.CloseDialog;
import com.mazadatimagepicker.Camera.CustomViews.ImageCropper;
import com.mazadatimagepicker.Camera.CustomViews.RectangleHole;
import com.mazadatimagepicker.Camera.DeleteDialog.DeleteDialog;
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

  private CameraView cameraView;
  private ImageView captureIm;
  private ImageView flashIm;

  //edit views
  private ConstraintLayout editCl;
  private ImageView image;
  private ImageCropper imageCropper;
  private Button cropBtn;
  private Button rotateBtn;
  private Button deleteBtn;

  private Button doneBtn;

  private ImageView confirmIm;
  private ImageView declineIm;

  private Button galleryBtn;
  private ImageView closeIm;

  private RectangleHole rectangleHole;

  private TextView maxImagesTv;
  private TextView captureHintTv;

  private RecyclerView recycler;
  private ImageItemsAdapter adapter;
  private LinkedList<ImageItem> imageItems;

  private int maxImagesSize;
  private int imageTurn = 0;
  private int selectedEditIndex = -1;
  private int editType = 0;

  private String lang;
  private String editPhotoPath;

  private boolean flashIsOn = false;
  private boolean isEditModeOn = false;
  private boolean editOnlyOnePhoto = false;

  private Drawable cropBlue;
  private Drawable cropWhite;
  private Drawable rotateBlue;
  private Drawable rotateWhite;

  private int rotationAngle = 0;

  private Bitmap originalBitmap;
  private Bitmap rotationBitmap;

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
    captureHintTv = findViewById(R.id.capture_hint_tv);
    galleryBtn = findViewById(R.id.gallery_btn);
    closeIm = findViewById(R.id.close_im);
    doneBtn = findViewById(R.id.done_btn);
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
    editOnlyOnePhoto = getIntent().getBooleanExtra("editOnlyOnePhoto", false);
    lang = getIntent().getStringExtra("lang");

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
    doneBtn.setOnClickListener(view -> donePressed());

    //edit views
    cropBtn.setOnClickListener(view -> cropPressed());
    rotateBtn.setOnClickListener(view -> rotatePressed());
    deleteBtn.setOnClickListener(view -> deletePressed());
    confirmIm.setOnClickListener(view -> confirmPressed());
    declineIm.setOnClickListener(view -> resetPressed());

    if(editOnlyOnePhoto){
      editPhotoPath=getIntent().getStringExtra("path");
      imageItems.get(0).setFile(new File(editPhotoPath));
      editOrCapturePhoto(0);
      recycler.setVisibility(View.GONE);
      captureHintTv.setVisibility(View.GONE);
      maxImagesTv.setVisibility(View.GONE);
      captureIm.setVisibility(View.GONE);
      galleryBtn.setVisibility(View.GONE);
      flashIm.setVisibility(View.GONE);
      deleteBtn.setVisibility(View.GONE);
    }
  }

  public String getLang() {
    return lang;
  }

  private void openGallery() {
    if(imageTurn == maxImagesSize){
      return;
    }
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
    if(imageItems.size()>1 || (imageItems.size()==1 && imageItems.get(0).getFile()!=null)){
      CloseDialog dialog = new CloseDialog();
      dialog.setCameraActivity(this);
      dialog.show(getSupportFragmentManager(), "dialog");
    }else{
      finish();
    }

  }

  private void donePressed(){
    if(editType>0){
      return;
    }
    String output="";
    for(int i=0;i<imageItems.size();i++){
      if(imageItems.get(i).getFile()!=null){
        output+=imageItems.get(i).getFile().getPath()+",";
      }
    }
    if(output.length()>0) {
      output = output.substring(0, output.length() - 1);
    }
    Intent intent = new Intent();
    intent.setAction(BuildConfig.BROADCAST_ACTION);
    intent.putExtra("data", output);
    sendBroadcast(intent);
    finish();
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
        cameraView.setSnapshotMaxWidth(rectangleHole.getWidth());
        cameraView.setSnapshotMaxHeight(rectangleHole.getHeight());
        result.toBitmap(rectangleHole.getWidth(), rectangleHole.getHeight(), bitmap -> {
          assert bitmap != null;
          File originalFile = ImageUtils.bitmapToFile(CameraActivity.this, bitmap);
          bitmap=ImageUtils.checkBitmapIfRotated(bitmap,originalFile.getPath());

          Log.i("datadata_width",bitmap.getWidth()+" "+rectangleHole.getWidth());

          Rect scaledRectangle= getScaledRect(bitmap.getWidth(),bitmap.getHeight());
          Bitmap croppedBitmap = Bitmap.createBitmap(bitmap, scaledRectangle.left, scaledRectangle.top, scaledRectangle.width(), scaledRectangle.height());

          File file = ImageUtils.bitmapToFile(CameraActivity.this, croppedBitmap);
          addImageToList(file);
        });

      }
    });
  }
  private Rect getScaledRect(int originalBitmapWidth, int originalBitmapHeight){
    int rectangleWidth=rectangleHole.getWidth();
    int rectangleHeight=rectangleHole.getHeight();
    int left = (int) rectangleHole.getFocusArea().left * originalBitmapWidth / rectangleWidth;
    int top = (int) rectangleHole.getFocusArea().top * originalBitmapHeight / rectangleHeight;
    int width = (int) rectangleHole.getFocusArea().width() * originalBitmapWidth / rectangleWidth;
    int height = width * rectangleHole.getAspectRatioY() / rectangleHole.getAspectRatioX();
    //int height = (int) rectangleHole.getFocusArea().top * originalBitmapHeight / rectangleHeight;
    Log.i("datadata_ratio",width+" "+height);
    return new Rect(left,top,left+width,top+height);

  }

  private void addImageToList(File file) {

    imageItems.get(imageTurn).setFile(file);
    adapter.notifyItemChanged(imageTurn);
    recycler.smoothScrollToPosition(imageTurn);

    imageTurn++;
    if (imageTurn < maxImagesSize) {
      doneBtn.setText(getString(R.string.done) + " (" + (imageTurn) + ")");
      imageItems.addLast(new ImageItem());
      adapter.notifyItemInserted(imageTurn);
    } else {
      doneBtn.setText(getString(R.string.done) + " (" + (maxImagesSize) + ")");
      maxImagesTv.setTextColor(getResources().getColor(R.color.red));
      captureIm.setEnabled(false);
      captureIm.setAlpha(0.38f);
    }
  }

  public void editOrCapturePhoto(int position) {
    if (imageItems.get(position).getFile() != null) {

      selectedEditIndex = position;

      editCl.setVisibility(View.VISIBLE);
      confirmIm.setVisibility(View.VISIBLE);

      galleryBtn.setVisibility(View.GONE);
      flashIm.setVisibility(View.GONE);
      cameraView.setVisibility(View.GONE);
      captureIm.setVisibility(View.GONE);
      cameraView.close();
      cameraView.stopVideo();

      confirmIm.setAlpha(0.38f);

      image.setImageURI(Uri.fromFile(imageItems.get(position).getFile()));
      isEditModeOn = true;
      resetPressed();

      cropBtn.setAlpha(1.0f);
      rotateBtn.setAlpha(1.0f);
      deleteBtn.setAlpha(1.0f);

    } else if (imageItems.get(position).getFile() == null && isEditModeOn && editType == 0) {
      resetAndOpenCamera();
    }
  }

  private void resetAndOpenCamera() {
    editCl.setVisibility(View.GONE);
    confirmIm.setVisibility(View.GONE);
    declineIm.setVisibility(View.GONE);
    captureIm.setVisibility(View.VISIBLE);
    cameraView.setVisibility(View.VISIBLE);

    galleryBtn.setVisibility(View.VISIBLE);
    flashIm.setVisibility(View.VISIBLE);

    cameraView.open();

    cropBtn.setAlpha(0.38f);
    rotateBtn.setAlpha(0.38f);
    deleteBtn.setAlpha(0.38f);

    isEditModeOn = false;
    editType = 0;

    declineIm.setVisibility(View.GONE);
    confirmIm.setVisibility(View.GONE);
  }

  private void cropPressed() {
    if (isEditModeOn && editType == 0) {
      editType = 1;
      cropBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, cropBlue, null, null);
      imageCropper.setVisibility(View.VISIBLE);
      imageCropper.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
      declineIm.setVisibility(View.VISIBLE);
      confirmIm.setAlpha(1.0f);
    }
  }

  private void rotatePressed() {
    if (isEditModeOn && editType == 0) {
      editType = 2;
      rotateBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, rotateBlue, null, null);
      originalBitmap = BitmapFactory.decodeFile(imageItems.get(selectedEditIndex).getFile().getPath());
      declineIm.setVisibility(View.VISIBLE);
      confirmIm.setAlpha(1.0f);
      rotateImage();
    } else if (isEditModeOn && editType == 2) {
      rotateImage();
    }
  }

  private void rotateImage() {
    rotationAngle += -90;
    rotationBitmap = ImageUtils.rotateBitmap(originalBitmap, rotationAngle);
    rotationBitmap = ImageUtils.createBitmap(image.getWidth(), image.getHeight(), rotationBitmap);
    image.setImageBitmap(rotationBitmap);
  }

  private void deletePressed() {
    DeleteDialog dialog = new DeleteDialog();
    dialog.setCameraActivity(this);
    dialog.show(getSupportFragmentManager(), "dialog");
  }

  public void deleteConfirmed() {
    editType=3;
    imageItems.remove(selectedEditIndex);
    if (imageTurn == maxImagesSize) {
      maxImagesTv.setTextColor(getResources().getColor(R.color.white_74));
      captureIm.setEnabled(true);
      captureIm.setAlpha(1f);
      imageItems.addLast(new ImageItem());
    }
    adapter.notifyDataSetChanged();
    imageTurn--;
    if(imageTurn>0) {
      doneBtn.setText(getString(R.string.done) + " (" + (imageTurn) + ")");
    }else{
      doneBtn.setText(getString(R.string.done));
    }
    resetPressed();
    resetAndOpenCamera();
  }

  private void confirmPressed() {
    if (editType == 1) {
      Bitmap croppedBitmap = imageCropper.crop();
      File file = ImageUtils.bitmapToFile(this, croppedBitmap);
      imageItems.get(selectedEditIndex).setFile(file);
      adapter.notifyItemChanged(selectedEditIndex);
    } else if (editType == 2) {
      File file = ImageUtils.bitmapToFile(this, rotationBitmap);
      imageItems.get(selectedEditIndex).setFile(file);
      adapter.notifyItemChanged(selectedEditIndex);
    }

    image.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
    resetPressed();
  }

  private void resetPressed() {
    if(editType==2){
      image.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
    }
    rotationAngle=0;
    imageCropper.setVisibility(View.GONE);
    cropBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, cropWhite, null, null);
    rotateBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, rotateWhite, null, null);
    editType = 0;
    declineIm.setVisibility(View.GONE);
    confirmIm.setAlpha(0.38f);
  }


  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (resultCode == RESULT_OK && requestCode == GALLERY_REQUEST_CODE) {
      String path = data.getStringExtra("path");
      addImageToList(new File(path));
    }
  }
}
