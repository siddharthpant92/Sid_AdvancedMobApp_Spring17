package com.example.siddharth.globetrotter;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

public class NewPlaceActivity extends AppCompatActivity {

    String tag = "NewPlaceAcitvity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place);
    }

    public void extraNotesTapped(View view)
    {
        Intent intent = new Intent(NewPlaceActivity.this, NewPlaceExtraActivity.class);
        startActivity(intent);
    }
}
