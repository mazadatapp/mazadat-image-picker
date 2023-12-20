package com.mazadatimagepicker.Camera;


import android.Manifest;
import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.RectF;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewPropertyAnimator;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.Camera;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageCapture;
import androidx.camera.core.Preview;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.constraintlayout.widget.ConstraintLayout;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.androidnetworking.AndroidNetworking;
import com.androidnetworking.error.ANError;
import com.androidnetworking.interfaces.DownloadListener;
import com.bumptech.glide.Glide;
import com.google.common.util.concurrent.ListenableFuture;
import com.mazadatimagepicker.BuildConfig;
import com.mazadatimagepicker.Camera.CloseDialog.CloseDialog;
import com.mazadatimagepicker.Camera.CustomViews.RectangleHole;
import com.mazadatimagepicker.Camera.CustomViews.ZoomImage;
import com.mazadatimagepicker.Camera.DeleteDialog.DeleteDialog;
import com.mazadatimagepicker.Camera.Gallery.Gallery;
import com.mazadatimagepicker.Camera.Image.ImageItem;
import com.mazadatimagepicker.Camera.Image.ImageItemsAdapter;
import com.mazadatimagepicker.Camera.Utils.ImageUtils;
import com.mazadatimagepicker.R;

import java.io.File;
import java.util.ArrayList;
import java.util.LinkedList;

public class PickerCameraActivity extends AppCompatActivity {

  final int GALLERY_REQUEST_CODE = 10;
  final int CAMERA_PERMISSION = 21;
  private PreviewView previewView;
  private ImageView captureIm;
  private ImageView flashIm;

  //edit views
  private ConstraintLayout editCl;
  private ImageView image;
  private ZoomImage imageCropper;
  private ProgressBar downloadPb;
  private TextView downloadTv;
  private ImageView zoomIm;
  private Button cropBtn;
  private Button rotateBtn;
  private Button deleteBtn;

  private Button doneBtn;

  private TextView confirmTv;
  private TextView declineTv;

  private Button galleryBtn;

  private RectangleHole rectangleHole;

  private TextView maxImagesTv;
  private TextView captureHintTv;

  private RecyclerView recycler;
  private ConstraintLayout loadingCl;
  private ImageItemsAdapter adapter;
  private LinkedList<ImageItem> imageItems = new LinkedList<>();

  private int maxImagesSize;
  private int imageTurn = 0;
  private int selectedEditIndex = -1;
  private int selectedPosition = 0;
  private EditModeTypes editType = EditModeTypes.NOTHING;

  private String lang;

  private boolean flashIsOn = false;
  private boolean isEditModeOn = false;
  private boolean isIdVerification = false;

  private Drawable cropBlue;
  private Drawable cropWhite;
  private Drawable rotateBlue;
  private Drawable rotateWhite;

  private int rotationAngle = 0;

  private Bitmap originalBitmap;
  private Bitmap rotationBitmap;

  private ListenableFuture<ProcessCameraProvider> cameraProviderFuture;
  private Camera camera;
  private boolean cameraPermissionEnabled = false;
  private boolean canPressDone = false;
  private float oldZoomScale = 0;

  private int editIndex = -1;
  private boolean showZoomIndicatorOnce = true;

  @SuppressLint("SetTextI18n")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_picker_camera);

    previewView = findViewById(R.id.preview);
    captureIm = findViewById(R.id.capture_im);
    flashIm = findViewById(R.id.flash_im);
    recycler = findViewById(R.id.recycler);
    rectangleHole = findViewById(R.id.rectangle_hole);
    maxImagesTv = findViewById(R.id.max_images_tv);
    captureHintTv = findViewById(R.id.capture_hint_tv);
    galleryBtn = findViewById(R.id.gallery_btn);
    ImageView closeIm = findViewById(R.id.close_im);
    doneBtn = findViewById(R.id.done_btn);
    //edit views
    editCl = findViewById(R.id.edit_cl);
    imageCropper = findViewById(R.id.image_cropper);
    downloadPb = findViewById(R.id.download_pb);
    downloadTv = findViewById(R.id.download_tv);
    zoomIm = findViewById(R.id.zoom_im);
    image = findViewById(R.id.image);
    cropBtn = findViewById(R.id.crop_btn);
    rotateBtn = findViewById(R.id.rotate_btn);
    deleteBtn = findViewById(R.id.delete_btn);

    confirmTv = findViewById(R.id.confirm_tv);
    declineTv = findViewById(R.id.decline_tv);

    loadingCl = findViewById(R.id.loading_cl);

    cropBlue = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_crop_blue, getTheme());
    cropWhite = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_crop, getTheme());
    rotateBlue = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_rotate_blue, getTheme());
    rotateWhite = ResourcesCompat.getDrawable(getResources(), R.drawable.ic_rotate, getTheme());

    maxImagesSize = getIntent().getIntExtra("maxImagesSize", 0);
    boolean editPhotosMode = getIntent().getBooleanExtra("editPhotosMode", false);
    lang = getIntent().getStringExtra("lang");
    isIdVerification = getIntent().getBooleanExtra("isIdVerification", false);

    maxImagesTv.setText(String.format("%s %s", getString(R.string.max_number_selected_images_is), maxImagesSize));

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
    confirmTv.setOnClickListener(view -> confirmPressed());
    declineTv.setOnClickListener(view -> resetPressed());

    if (isIdVerification) {
      maxImagesTv.setVisibility(View.INVISIBLE);
    }
    if (editPhotosMode) {
      editIndex = getIntent().getIntExtra("index", -1);
      String[] editPhotoPath = getIntent().getStringArrayExtra("paths");
      for (int i = 0; i < editPhotoPath.length; i++) {
        if (editPhotoPath[i].contains("https://") || editPhotoPath[i].contains("http://")) {
          imageItems.addLast(new ImageItem(editPhotoPath[i]));
        } else {
          imageItems.addLast(new ImageItem(new File(editPhotoPath[i])));
        }
      }
      doneBtn.setBackgroundResource(R.drawable.custom_blue_round_15);
      doneBtn.setTextColor(getResources().getColor(R.color.white));
      canPressDone = true;
      doneBtn.setText(getString(R.string.done) + " (" + imageItems.size() + ")");
      editOrCapturePhoto(editIndex);

      //recycler.setVisibility(View.GONE);
      captureHintTv.setVisibility(View.GONE);
      maxImagesTv.setVisibility(View.GONE);
      captureIm.setVisibility(View.GONE);
      galleryBtn.setVisibility(View.GONE);
      flashIm.setVisibility(View.GONE);
      deleteBtn.setVisibility(View.GONE);


    } else {
      cameraHandler();
      imageItems.addLast(new ImageItem());
      checkDoneButton();
      doneBtn.setText(getString(R.string.done) + " (0)");
    }

    setHintText();

    imageCropper.setZoomListener(zoomScale -> {
      if (zoomScale != oldZoomScale) {
        confirmTv.setAlpha(1.0f);
        declineTv.setAlpha(1.0f);

        confirmTv.setEnabled(true);
        declineTv.setEnabled(true);
        editType = EditModeTypes.CROP;
        disableDoneBtn();
      }
    });
  }

  private void downloadImage(String url) {

    String name = url.split("/")[url.split("/").length - 1];
    if (!name.toLowerCase().endsWith(".png") && !name.toLowerCase().endsWith(".jpeg") && !name.toLowerCase().endsWith(".jpg")
      && !name.toLowerCase().endsWith(".svg") && !name.toLowerCase().endsWith(".webp")) {
      name += ".jpg";
    }
    String finalName = name;
    AndroidNetworking.download(url, getCacheDir().getPath(), name).build().setDownloadProgressListener((l, l1) -> {
      int percentage = (int) ((double) l * 100.0 / (double) l1);
      downloadTv.setText(percentage + "%");
    }).startDownload(new DownloadListener() {
      @Override
      public void onDownloadComplete() {
        File file = new File(getCacheDir().getPath(), finalName);
        imageItems.get(0).setFile(file);
        downloadPb.setVisibility(View.GONE);
        downloadTv.setVisibility(View.GONE);
        canPressDone = true;
        editOrCapturePhoto(0);
      }

      @Override
      public void onError(ANError anError) {
        anError.printStackTrace();
      }
    });

  }

  private void setHintText() {
    if (editType == EditModeTypes.CROP) {
      captureHintTv.setText(getString(R.string.zoom_hint));
    } else if (editType == EditModeTypes.ROTATE) {
      captureHintTv.setText(getString(R.string.rotate_hint));
    } else {
      captureHintTv.setText(isIdVerification ? getString(R.string.id_verification_hint) : getString(R.string.camera_capture_hint));
    }
  }

  public boolean isIdVerification() {
    return isIdVerification;
  }

  public String getLang() {
    return lang;
  }

  private void openGallery() {
    if (imageTurn == maxImagesSize) {
      return;
    }
    boolean permissionFlag = true;
    if (Build.VERSION.SDK_INT >= 23 && Build.VERSION.SDK_INT < 30) {
      permissionFlag = ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
    }
    if (permissionFlag) {
      startActivityForResult(new Intent(this, Gallery.class).putExtra("maxImagesNumber", maxImagesSize - imageTurn), GALLERY_REQUEST_CODE);
    } else {
      String[] permissions = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE};
      int READ_WRITE_REQUEST_PERMISSION = 20;
      ActivityCompat.requestPermissions(this,
        permissions,
        READ_WRITE_REQUEST_PERMISSION);
    }

  }

  private void checkDoneButton() {
    doneBtn.setBackgroundResource(imageTurn == 0 ? R.drawable.custom_gray_round_15 : R.drawable.custom_blue_round_15);
    doneBtn.setTextColor(getResources().getColor(imageTurn == 0 ? R.color.black_26 : R.color.white));
    canPressDone = (imageTurn > 0);
  }

  private void enableDoneBtn() {
    doneBtn.setBackgroundResource(R.drawable.custom_blue_round_15);
    doneBtn.setTextColor(getResources().getColor(R.color.white));
    canPressDone = true;
  }

  private void disableDoneBtn() {
    doneBtn.setBackgroundResource(R.drawable.custom_gray_round_15);
    doneBtn.setTextColor(getResources().getColor(R.color.black_26));
    canPressDone = false;
  }

  private void openClosConfirmationDialog() {
    if (imageItems.size() > 1 || (imageItems.size() == 1 && imageItems.get(0).getFile() != null)) {
      CloseDialog dialog = new CloseDialog();
      dialog.setCameraActivity(this);
      dialog.show(getSupportFragmentManager(), "dialog");
    } else {
      finish();
    }

  }

  private void donePressed() {
    boolean imagesAreReady = true;
    for (int i = 0; i < imageItems.size(); i++) {
      if (imageItems.get(i).getUrl() != null) {
        imagesAreReady = false;
      }
    }
    if (!canPressDone || !imagesAreReady) {
      return;
    }

    if (editType != EditModeTypes.NOTHING) {
      return;
    }

    if (isIdVerification) {
      if (imageItems.get(0).getFile() == null) {
        Toast.makeText(this, getString(R.string.please_add_front_id), Toast.LENGTH_SHORT).show();
        return;
      } else if (imageItems.get(1).getFile() == null) {
        Toast.makeText(this, getString(R.string.please_add_back_id), Toast.LENGTH_SHORT).show();
        return;
      }
    }
    StringBuilder output = new StringBuilder();
    for (int i = 0; i < imageItems.size(); i++) {
      if (imageItems.get(i).getFile() != null) {
        output.append(imageItems.get(i).getFile().getPath()).append(",");
      }
    }
    if (output.length() > 0) {
      output = new StringBuilder(output.substring(0, output.length() - 1));
    }
    Intent intent = new Intent();
    intent.setAction(BuildConfig.BROADCAST_ACTION);
    intent.putExtra("data", output.toString());
    sendBroadcast(intent);
    finish();
  }

  private void capturePressed() {
    if (!cameraPermissionEnabled) {
      return;
    }
    rectangleHole.animateFrame();
    Bitmap scaledBitmap = previewView.getBitmap();
    assert scaledBitmap != null;
    float width = (0.91f * scaledBitmap.getWidth());
    float height = (width * rectangleHole.getAspectRatioY() / rectangleHole.getAspectRatioX());
    RectF rect = new RectF(scaledBitmap.getWidth() / 2f - width / 2f, scaledBitmap.getHeight() * 0.2f, scaledBitmap.getWidth() / 2f - width / 2f + width, scaledBitmap.getHeight() * 0.2f + height);


    Bitmap croppedBitmap = Bitmap.createBitmap(scaledBitmap, (int) rect.left, (int) rect.top, (int) rect.width(), (int) rect.height());
    File file = ImageUtils.bitmapToFile(PickerCameraActivity.this, croppedBitmap);
    addImageToList(file);

  }

  private void flashPressed() {
    flashIsOn = !flashIsOn;
    flashIm.setImageResource(flashIsOn ? R.drawable.ic_flash_on : R.drawable.ic_flash_off);

    camera.getCameraControl().enableTorch(flashIsOn);
  }

  @Override
  protected void onResume() {
    super.onResume();
    //cameraView.open();
  }

  @Override
  protected void onStop() {
    super.onStop();
  }

  private void cameraHandler() {

    cameraProviderFuture = ProcessCameraProvider.getInstance(this);
    cameraProviderFuture.addListener(() -> {
      try {
        ProcessCameraProvider cameraProvider = cameraProviderFuture.get();

        if (ContextCompat.checkSelfPermission(PickerCameraActivity.this, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
          cameraPermissionEnabled = true;
          startCameraX(cameraProvider);
        } else {
          ActivityCompat.requestPermissions(PickerCameraActivity.this,
            new String[]{Manifest.permission.CAMERA},
            CAMERA_PERMISSION);
        }

      } catch (Exception e) {
        e.printStackTrace();
      }
    }, ContextCompat.getMainExecutor(this));


  }

  private void startCameraX(ProcessCameraProvider cameraProvider) {
    cameraProvider.unbindAll();
    CameraSelector cameraSelector = new CameraSelector.Builder().requireLensFacing(CameraSelector.LENS_FACING_BACK).build();
    Preview preview = new Preview.Builder().build();
    preview.setSurfaceProvider(previewView.getSurfaceProvider());

    ImageCapture imageCapture = new ImageCapture.Builder().setCaptureMode(ImageCapture.CAPTURE_MODE_MINIMIZE_LATENCY).build();
    camera = cameraProvider.bindToLifecycle(this, cameraSelector, preview, imageCapture);
  }

  public int getSelectedPosition() {
    return selectedPosition;
  }

  private void addImageToList(File file) {

    imageItems.get(imageTurn).setFile(file);
    adapter.notifyItemChanged(imageTurn);


    imageTurn++;
    selectedPosition = imageTurn;
    if (imageTurn < maxImagesSize) {
      doneBtn.setText(getString(R.string.done) + " (" + imageTurn + ")");
      imageItems.addLast(new ImageItem());
      recycler.smoothScrollToPosition(imageTurn);
    } else {
      doneBtn.setText(getString(R.string.done) + " (" + (maxImagesSize) + ")");
      maxImagesTv.setTextColor(getResources().getColor(R.color.red));
      captureIm.setEnabled(false);
      captureIm.setAlpha(0.38f);
    }

    checkDoneButton();
    adapter.notifyDataSetChanged();
  }

  public void editOrCapturePhoto(int position) {

    if (imageItems.get(position).getFile() != null && editType == EditModeTypes.NOTHING) {

      selectedEditIndex = position;
      selectedPosition = position;
      adapter.notifyDataSetChanged();

      editCl.setVisibility(View.VISIBLE);
      confirmTv.setVisibility(View.GONE);

      galleryBtn.setVisibility(View.GONE);
      flashIm.setVisibility(View.GONE);
      previewView.setVisibility(View.GONE);
      captureIm.setVisibility(View.GONE);
      Glide.with(this).load(Uri.fromFile(imageItems.get(selectedEditIndex).getFile())).into(image);
      //image.setImageURI(Uri.fromFile(imageItems.get(position).getFile()));
      isEditModeOn = true;
      resetPressed();

      cropBtn.setAlpha(1.0f);
      rotateBtn.setAlpha(1.0f);
      deleteBtn.setAlpha(1.0f);
      cropPressed();

    } else if (imageItems.get(position).getFile() == null && isEditModeOn && editType == EditModeTypes.NOTHING) {
      resetAndOpenCamera();
      selectedPosition = imageTurn;
      adapter.notifyDataSetChanged();
    }
  }

  private void resetAndOpenCamera() {
    editCl.setVisibility(View.GONE);
    confirmTv.setVisibility(View.GONE);
    declineTv.setVisibility(View.GONE);
    captureIm.setVisibility(View.VISIBLE);
    previewView.setVisibility(View.VISIBLE);

    galleryBtn.setVisibility(View.VISIBLE);
    flashIm.setVisibility(View.VISIBLE);

    cropBtn.setAlpha(0.38f);
    rotateBtn.setAlpha(0.38f);
    deleteBtn.setAlpha(0.38f);

    isEditModeOn = false;
    editType = EditModeTypes.NOTHING;

    declineTv.setVisibility(View.GONE);
    confirmTv.setVisibility(View.GONE);

    recycler.smoothScrollToPosition(imageItems.size() - 1);
    selectedPosition = imageItems.size() - 1;
    adapter.notifyDataSetChanged();
  }

  private void cropPressed() {
    if (isEditModeOn && editType == EditModeTypes.NOTHING) {
      if(showZoomIndicatorOnce){
        showZoomIndicatorOnce = false;
        zoomIm.setVisibility(View.VISIBLE);
        ViewPropertyAnimator animator = zoomIm.animate().alpha(0).setDuration(600).setStartDelay(1000);
        animator.setListener(new AnimatorListenerAdapter() {
          @Override
          public void onAnimationEnd(Animator animation) {
            super.onAnimationEnd(animation);
            zoomIm.setVisibility(View.GONE);
          }
        });
        animator.start();
      }
      setHintText();
      cropBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, cropBlue, null, null);
      imageCropper.setVisibility(View.VISIBLE);
      image.setVisibility(View.INVISIBLE);
      Glide.with(this).load(Uri.fromFile(imageItems.get(selectedEditIndex).getFile())).into(imageCropper);
      //imageCropper.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
      imageCropper.reset();
      declineTv.setVisibility(View.VISIBLE);
      confirmTv.setVisibility(View.VISIBLE);
      confirmTv.setAlpha(0.5f);
      declineTv.setAlpha(0.5f);

      confirmTv.setEnabled(false);
      declineTv.setEnabled(false);

      oldZoomScale = imageCropper.getCurrentScaleFactor();
    }
  }

  private void rotatePressed() {
    if (isEditModeOn && (editType == EditModeTypes.NOTHING || imageCropper.getCurrentScaleFactor() == oldZoomScale)) {
      if (imageCropper.getCurrentScaleFactor() == oldZoomScale && editType != EditModeTypes.ROTATE) {
        resetPressed();
      }
      editType = EditModeTypes.ROTATE;
      setHintText();
      rotateBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, rotateBlue, null, null);
      originalBitmap = BitmapFactory.decodeFile(imageItems.get(selectedEditIndex).getFile().getPath());
      declineTv.setVisibility(View.VISIBLE);
      confirmTv.setVisibility(View.VISIBLE);
      confirmTv.setAlpha(1.0f);
      declineTv.setAlpha(1.0f);

      confirmTv.setEnabled(true);
      declineTv.setEnabled(true);
      rotateImage();
      disableDoneBtn();
    } else if (isEditModeOn && editType == EditModeTypes.ROTATE) {
      rotateImage();
      disableDoneBtn();
    }
  }

  private void rotateImage() {
    rotationAngle += -90;
    if (originalBitmap.getWidth() * originalBitmap.getHeight() > 23040000) {

      AsyncTask.execute(() -> {
        runOnUiThread(() -> {
          loadingCl.setVisibility(View.VISIBLE);
        });
        rotationBitmap = ImageUtils.rotateBitmap(originalBitmap, rotationAngle);
        rotationBitmap = ImageUtils.createBitmap(originalBitmap.getWidth(), originalBitmap.getHeight(), rotationBitmap);
        runOnUiThread(() -> {
          Glide.with( this).load(rotationBitmap).into(image);
          loadingCl.setVisibility(View.GONE);
        });
      });
    }else{
      rotationBitmap = ImageUtils.rotateBitmap(originalBitmap, rotationAngle);
      rotationBitmap = ImageUtils.createBitmap(originalBitmap.getWidth(), originalBitmap.getHeight(), rotationBitmap);
      Glide.with(this).load(rotationBitmap).into(image);
    }


  }

  private void deletePressed() {
    if (isEditModeOn) {
      DeleteDialog dialog = new DeleteDialog();
      dialog.setCameraActivity(this);
      dialog.show(getSupportFragmentManager(), "dialog");
    }
  }

  public void deleteConfirmed() {
    editType = EditModeTypes.DELETE;
    imageItems.remove(selectedEditIndex);
    if (imageTurn == maxImagesSize) {
      maxImagesTv.setTextColor(getResources().getColor(R.color.white_74));
      captureIm.setEnabled(true);
      captureIm.setAlpha(1f);
      imageItems.addLast(new ImageItem());
    }
    adapter.notifyDataSetChanged();
    imageTurn--;
    doneBtn.setText(getString(R.string.done) + " (" + (imageTurn) + ")");
    resetPressed();
    resetAndOpenCamera();
    checkDoneButton();
    setHintText();
  }

  public void reloadItem(int index) {
    runOnUiThread(() -> {
      recycler.post(() -> adapter.notifyItemChanged(index));
      if (editIndex == index) {
        editOrCapturePhoto(editIndex);
      }
    });


  }

  private void confirmPressed() {
    if (editType == EditModeTypes.CROP) {
      imageCropper.setShowGrid(false);
      Bitmap croppedBitmap = getBitmapFromView(imageCropper);
      imageCropper.setShowGrid(true);
      File file = ImageUtils.bitmapToFile(this, croppedBitmap);
      imageItems.get(selectedEditIndex).setFile(file);
      adapter.notifyItemChanged(selectedEditIndex);
    } else if (editType == EditModeTypes.ROTATE) {
      File file = ImageUtils.bitmapToFile(this, rotationBitmap);
      imageItems.get(selectedEditIndex).setFile(file);
      adapter.notifyItemChanged(selectedEditIndex);
    }

    Glide.with(this).load(Uri.fromFile(imageItems.get(selectedEditIndex).getFile())).into(image);
    resetPressed();
  }

  private void resetPressed() {
    if (editType == EditModeTypes.ROTATE) {
      Glide.with(this).load(Uri.fromFile(imageItems.get(selectedEditIndex).getFile())).into(image);
      //image.setImageURI(Uri.fromFile(imageItems.get(selectedEditIndex).getFile()));
    }
    rotationAngle = 0;
    imageCropper.setVisibility(View.GONE);
    image.setVisibility(View.VISIBLE);
    cropBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, cropWhite, null, null);
    rotateBtn.setCompoundDrawablesRelativeWithIntrinsicBounds(null, rotateWhite, null, null);
    editType = EditModeTypes.NOTHING;
    declineTv.setVisibility(View.GONE);
    confirmTv.setVisibility(View.GONE);

    setHintText();
    enableDoneBtn();
  }

  private Bitmap getBitmapFromView(View view) {
    Bitmap returnedBitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight(), Bitmap.Config.ARGB_8888);
    Canvas canvas = new Canvas(returnedBitmap);
    Drawable bgDrawable = view.getBackground();
    if (bgDrawable != null)
      bgDrawable.draw(canvas);
    else
      canvas.drawColor(Color.TRANSPARENT);
    view.draw(canvas);
    return returnedBitmap;
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);

    if (resultCode == RESULT_OK && requestCode == GALLERY_REQUEST_CODE) {
      ArrayList<String> paths = data.getStringArrayListExtra("paths");
      for (int i = 0; i < paths.size(); i++) {
        addImageToList(new File(paths.get(i)));
      }
    }
  }

  @Override
  public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    if (requestCode == CAMERA_PERMISSION && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
      cameraPermissionEnabled = true;
      cameraHandler();
    }
  }
}
