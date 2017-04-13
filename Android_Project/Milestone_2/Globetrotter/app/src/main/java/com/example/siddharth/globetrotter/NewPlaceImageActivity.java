package com.example.siddharth.globetrotter;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

public class NewPlaceImageActivity extends AppCompatActivity {

    String tag = "NewPlaceImageActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_image);
    }

    public void cameraButtonTapped(View view)
    {
        Toast.makeText(NewPlaceImageActivity.this, "Camera button tapped", Toast.LENGTH_SHORT).show();
    }

    public void libraryButtonTapped(View view)
    {
        Toast.makeText(NewPlaceImageActivity.this, "Library button tapped", Toast.LENGTH_SHORT).show();
    }
}
