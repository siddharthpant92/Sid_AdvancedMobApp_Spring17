package com.example.siddharth.globetrotter;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

public class NewPlaceImageActivity extends AppCompatActivity {

    String tag = "NewPlaceImageActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_image);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {

        MenuInflater menuInflater = getMenuInflater();
        menuInflater.inflate(R.menu.menu_main, menu);

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {

        int itemId = item.getItemId();
        switch (itemId)
        {
            case (R.id.settings):
                Toast.makeText(NewPlaceImageActivity.this, "Save button tapped", Toast.LENGTH_SHORT).show();
        }

        return super.onOptionsItemSelected(item);
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
