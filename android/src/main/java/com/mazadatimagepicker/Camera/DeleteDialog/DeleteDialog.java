package com.mazadatimagepicker.Camera.DeleteDialog;

import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;

import com.mazadatimagepicker.Camera.CameraActivity;
import com.mazadatimagepicker.R;

public class DeleteDialog extends DialogFragment {


  private CameraActivity cameraActivity;

  @Nullable
  @Override
  public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
    requireDialog().requestWindowFeature(Window.FEATURE_NO_TITLE);

    View view = inflater.inflate(R.layout.dialog_delete_confirmation, container, false);

    Button cancelBtn=view.findViewById(R.id.cancel_btn);
    Button confirmDeleteBtn=view.findViewById(R.id.confirm_delete_btn);

    confirmDeleteBtn.setBackgroundResource(cameraActivity.getLang().equals("en") ?
      R.drawable.custom_gray_round_bottom_right_20 : R.drawable.custom_gray_round_bottom_left_20);
    cancelBtn.setBackgroundResource(cameraActivity.getLang().equals("en") ?
      R.drawable.custom_gray_round_bottom_left_20 : R.drawable.custom_gray_round_bottom_right_20);

    cancelBtn.setOnClickListener((v) -> dismiss());
    confirmDeleteBtn.setOnClickListener((v) ->{
      cameraActivity.deleteConfirmed();
      dismiss();
    });

    return view;
  }

  public void setCameraActivity(CameraActivity cameraActivity) {
    this.cameraActivity = cameraActivity;
  }

  @Override
  public void onStart() {
    super.onStart();

    getDialog().getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
    getDialog().getWindow().setGravity(Gravity.CENTER);
    getDialog().getWindow().setLayout((int)(getContext().getResources().getDisplayMetrics().widthPixels * 0.9), ViewGroup.LayoutParams.WRAP_CONTENT);
  }
}
