package com.mazadatimagepicker.Camera.Image;

import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.makeramen.roundedimageview.RoundedImageView;
import com.mazadatimagepicker.Camera.CameraActivity;
import com.mazadatimagepicker.R;

import java.util.LinkedList;


public class ImageItemsAdapter extends RecyclerView.Adapter<ImageItemsAdapter.ViewHolder> {

  public LinkedList<ImageItem> images;
  CameraActivity cameraActivity;

  // Pass in the contact array into the constructor
  public ImageItemsAdapter(CameraActivity cameraActivity, LinkedList<ImageItem> images) {

    this.cameraActivity = cameraActivity;
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

    LayoutInflater inflater = LayoutInflater.from(cameraActivity);

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

    RoundedImageView image;
    TextView selectToEdit;


    public ViewHolder(View itemView) {
      super(itemView);
      image = itemView.findViewById(R.id.image);
      selectToEdit = itemView.findViewById(R.id.select_to_edit_tv);

    }

    public void onBind(ImageItem model, int position) {
      selectToEdit.setVisibility(model.getFile() != null ? View.VISIBLE : View.GONE);
      if (model.getFile() != null) {
        image.setImageURI(Uri.fromFile(model.getFile()));
      } else {
        image.setImageDrawable(null);
      }

      itemView.setOnClickListener(view -> cameraActivity.editOrCapturePhoto(position));
    }

  }

}
