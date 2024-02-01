package com.mazadatimagepicker.Camera.Image;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Handler;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.recyclerview.widget.RecyclerView;

import com.budiyev.android.circularprogressbar.CircularProgressBar;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.DataSource;
import com.bumptech.glide.load.engine.GlideException;
import com.bumptech.glide.request.RequestListener;
import com.bumptech.glide.request.RequestOptions;
import com.bumptech.glide.request.target.Target;
import com.makeramen.roundedimageview.RoundedImageView;
import com.mazadatimagepicker.Camera.CustomViews.ZoomImage;
import com.mazadatimagepicker.Camera.PickerCameraActivity;
import com.mazadatimagepicker.Camera.Utils.ImageUtils;
import com.mazadatimagepicker.R;

import java.io.File;
import java.util.LinkedList;


public class ImageItemsAdapter extends RecyclerView.Adapter<ImageItemsAdapter.ViewHolder> {

  public LinkedList<ImageItem> images;
  PickerCameraActivity pickerCameraActivity;

  // Pass in the contact array into the constructor
  public ImageItemsAdapter(PickerCameraActivity pickerCameraActivity, LinkedList<ImageItem> images) {

    this.pickerCameraActivity = pickerCameraActivity;
    this.images = images;

  }

  @Override
  public int getItemViewType(int position) {
    return position;
  }

  // Usually involves inflating a layout from XML and returning the holder
  @NonNull
  @Override
  public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

    LayoutInflater inflater = LayoutInflater.from(pickerCameraActivity);

    View invitationView = inflater.inflate(R.layout.adapter_image_item, parent, false);

    return new ViewHolder(invitationView);

  }

  // Involves populating data into the item through holder
  @Override
  public void onBindViewHolder(@NonNull ViewHolder holder, int position) {

    // Get the data model based on position
    holder.onBind(images.get(position), position);
  }

  // Returns the total count of items in the list
  @Override
  public int getItemCount() {
    return images.size();
  }

  public class ViewHolder extends RecyclerView.ViewHolder {

    ZoomImage image;
    RoundedImageView overlayIm;
    TextView selectToEdit;
    CircularProgressBar progress;
    TextView idTypeTv;


    public ViewHolder(View itemView) {
      super(itemView);
      image = itemView.findViewById(R.id.image);
      progress = itemView.findViewById(R.id.progress);
      overlayIm = itemView.findViewById(R.id.overlay_im);
      selectToEdit = itemView.findViewById(R.id.select_to_edit_tv);
      idTypeTv = itemView.findViewById(R.id.id_type_tv);

    }

    public void onBind(ImageItem model, int position) {
      selectToEdit.setVisibility((model.getFile() != null && position != pickerCameraActivity.getSelectedPosition()) ? View.VISIBLE : View.GONE);
      if(model.getZoomImage()==null){
        model.setZoomImage(image);
      }
      image.setShowGrid(false);
      if (model.getFile() != null) {
        Glide.with(pickerCameraActivity).load(Uri.fromFile(model.getFile())).into(image);
        Log.i("datadata_edit",model.isUpdateZoomOnce()+" "+position);
        if(!model.isUpdateZoomOnce()) {
          updateZoomInBackGround(model.getFile(), null, image,position);
          model.setUpdateZoomOnce(true);
        }else{
          image.setZoom(model.getZoomLevel());
        }
        overlayIm.setAlpha(1.0f);
        image.setAlpha(1.0f);
        progress.setVisibility(View.GONE);
      } else if (model.getUrl() != null) {
        checkIfImageExist(model, position, true);
        image.setAlpha(0.5f);
        overlayIm.setAlpha(1.0f);
      } else {
        image.setImageDrawable(null);
        overlayIm.setAlpha(0.0f);
      }

      idTypeTv.setVisibility(pickerCameraActivity.isIdVerification() ? View.VISIBLE : View.GONE);

      if (pickerCameraActivity.isIdVerification()) {
        if (position == 0) {
          idTypeTv.setText(pickerCameraActivity.getString(R.string.front_id));
        } else {
          idTypeTv.setText(pickerCameraActivity.getString(R.string.back_id));
        }
      }


      itemView.setBackgroundResource(pickerCameraActivity.getSelectedPosition() == position ? R.drawable.custom_image_boarder : R.drawable.custom_image);
      if (model.getUrl() == null) {
        overlayIm.setOnClickListener(view -> pickerCameraActivity.editOrCapturePhoto(position));
      } else {
        overlayIm.setOnClickListener(null);
      }
    }

    private void updateZoomInBackGround(File file,Bitmap bitmap,ZoomImage zoomImage,int position) {
      final Bitmap[] finalBitmap = new Bitmap[1];
      AsyncTask.execute(() -> {
        if(file!=null){
          finalBitmap[0] = BitmapFactory.decodeFile(file.getPath());
        }else{
          finalBitmap[0] = bitmap;
        }
        images.get(position).setZoomLevel(pickerCameraActivity.updateImageZoom(finalBitmap[0],zoomImage));
        images.get(position).setUpdateZoomOnce(true);
        pickerCameraActivity.reloadItem(position);
       // pickerCameraActivity.runOnUiThread(()->notifyItemChanged(position));
      });

    }

    private void checkIfImageExist(ImageItem model, int position, boolean fromCache) {
      Glide.with(pickerCameraActivity)
        .asBitmap()
        .load(model.getUrl())
        .apply(new RequestOptions().onlyRetrieveFromCache(fromCache))
        .listener(new RequestListener<Bitmap>() {
          @Override
          public boolean onLoadFailed(@Nullable GlideException e, @Nullable Object model_, @NonNull Target<Bitmap> target, boolean isFirstResource) {
            new Handler().post(() -> checkIfImageExist(model, position, false));
            progress.setVisibility(View.VISIBLE);
            return true;
          }

          @Override
          public boolean onResourceReady(@NonNull Bitmap bitmap, @NonNull Object model_, Target<Bitmap> target, @NonNull DataSource dataSource, boolean isFirstResource) {
            AsyncTask.execute(() -> {
              File file = ImageUtils.bitmapToFile(pickerCameraActivity,
              //  ImageUtils.createBitmap(bitmap.getWidth(), (int) (bitmap.getWidth() * 3f / 4f), bitmap));
                bitmap);
              model.setUrl(null);
              model.setFile(file);
              model.setImageWidth(bitmap.getWidth());
              model.setImageHeight(bitmap.getHeight());
              pickerCameraActivity.reloadItem(position);
            });
            return true;
          }
        })
        .into(image);
    }

  }

}
