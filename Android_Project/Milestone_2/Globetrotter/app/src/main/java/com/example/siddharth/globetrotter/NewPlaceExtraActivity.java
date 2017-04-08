package com.example.siddharth.globetrotter;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;

public class NewPlaceExtraActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_extra);
    }

    public void newPlaceImageTapped(View view)
    {
        Intent intent = new Intent(NewPlaceExtraActivity.this, NewPlaceImageActivity.class);
        startActivity(intent);
    }
}
