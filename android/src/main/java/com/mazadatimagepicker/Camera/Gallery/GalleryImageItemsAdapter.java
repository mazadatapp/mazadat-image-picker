package com.mazadatimagepicker.Camera.Gallery;

import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.makeramen.roundedimageview.RoundedImageView;
import com.mazadatimagepicker.R;

import java.util.LinkedList;


public class GalleryImageItemsAdapter extends RecyclerView.Adapter<GalleryImageItemsAdapter.ViewHolder> {

  public LinkedList<GalleryItemModel> images;
  Gallery gallery;
  int selectedPosition;

  // Pass in the contact array into the constructor
  public GalleryImageItemsAdapter(Gallery gallery, LinkedList<GalleryItemModel> images) {

    this.gallery = gallery;
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

    LayoutInflater inflater = LayoutInflater.from(gallery);

    View invitationView = inflater.inflate(R.layout.adapter_gallery_image_item, parent, false);

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
    RoundedImageView overlayIm;
    ImageView selectedIm;


    public ViewHolder(View itemView) {
      super(itemView);
      image = itemView.findViewById(R.id.image);
      overlayIm = itemView.findViewById(R.id.overlay_im);
      selectedIm = itemView.findViewById(R.id.selected_im);

    }

    public void onBind(GalleryItemModel model, int position) {
      selectedIm.setVisibility(model.isCropped() ? View.VISIBLE : View.GONE);
      overlayIm.setVisibility(selectedPosition != position ? View.VISIBLE : View.GONE);
      if (model.getCroppedFile() == null) {
        image.setImageBitmap(model.getBitmap());
      } else {
        image.setImageURI(Uri.fromFile(model.getCroppedFile()));
      }
      itemView.setOnClickListener(view -> {
        gallery.switchImage(position);
      });
    }

  }

}
