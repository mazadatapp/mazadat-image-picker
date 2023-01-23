package com.mazadatimagepicker.Camera;


import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.mazadatimagepicker.R;
import com.otaliastudios.cameraview.CameraView;

public class CameraActivity extends AppCompatActivity {
    CameraView cameraView;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_camera);
        cameraView=findViewById(R.id.camera);
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
}
