package com.mazadatimagepicker.Camera.Image;

import android.net.Uri;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.makeramen.roundedimageview.RoundedImageView;
import com.mazadatimagepicker.Camera.PickerCameraActivity;
import com.mazadatimagepicker.R;

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

    RoundedImageView image;
    RoundedImageView overlayIm;
    TextView selectToEdit;
    TextView idTypeTv;


    public ViewHolder(View itemView) {
      super(itemView);
      image = itemView.findViewById(R.id.image);
      overlayIm = itemView.findViewById(R.id.overlay_im);
      selectToEdit = itemView.findViewById(R.id.select_to_edit_tv);
      idTypeTv = itemView.findViewById(R.id.id_type_tv);

    }

    public void onBind(ImageItem model, int position) {
      selectToEdit.setVisibility(model.getFile() != null ? View.VISIBLE : View.GONE);

      if (model.getFile() != null) {
        image.setImageURI(Uri.fromFile(model.getFile()));
        overlayIm.setVisibility(View.VISIBLE);
      } else {
        image.setImageDrawable(null);
        overlayIm.setVisibility(View.GONE);
      }

      idTypeTv.setVisibility(pickerCameraActivity.isIdVerification() ? View.VISIBLE : View.GONE);

      if(pickerCameraActivity.isIdVerification()){
        if (position == 0){
          idTypeTv.setText(pickerCameraActivity.getString(R.string.front_id));
        }else{
          idTypeTv.setText(pickerCameraActivity.getString(R.string.back_id));
        }
      }


      itemView.setBackgroundResource(pickerCameraActivity.getSelectedPosition() == position ?R.drawable.custom_image_boarder:R.drawable.custom_image);

      itemView.setOnClickListener(view -> pickerCameraActivity.editOrCapturePhoto(position));
    }

  }

}
