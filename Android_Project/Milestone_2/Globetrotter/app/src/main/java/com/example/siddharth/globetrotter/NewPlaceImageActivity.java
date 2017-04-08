package com.example.siddharth.globetrotter;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

public class NewPlaceImageActivity extends AppCompatActivity {

    String tag = "NewPlaceImageActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_image);
    }

    public void cameraButtonTapped(View view)
    {
        Log.d(tag, "camera will open uop");
    }

    public void libraryButtonTapped(View view)
    {
        Log.d(tag, "library will open up");
    }
}
