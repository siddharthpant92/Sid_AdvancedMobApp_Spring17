package com.example.siddharth.globetrotter;

import android.*;
import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
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

    private static final int MY_PERMISSIONS_REQUEST_STORAGE = 0;
    boolean resultStorage; //To store result of external storage permission
    int permissionAttempt; //User has 2 attempts to grant permission

    String place;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_image);

        Bundle bundle = getIntent().getExtras();
        place = bundle.getString("place");

        permissionAttempt = 1; //First time user is asked for permission
        checkPermissionStorage();
        Log.d(tag, "onCreate: "+resultStorage);
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
        if(!resultStorage) //Asking for permission again, second attempt
        {
            Log.d(tag, "asking for permission again");
            permissionAttempt = 2;
            checkPermissionStorage();
        }
        if(resultStorage)//Permission has already been granted
        {
            Log.d(tag, "user granted permission, open gallery");
        }
    }

    public void checkPermissionStorage()
    {
        if(Build.VERSION.SDK_INT >= 23)
        {
            if(checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED)
            {
                requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST_STORAGE);
            }
            else
            {
                resultStorage = true;
            }
        }
        else
        {
            resultStorage = true;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults)
    {
        switch (requestCode)
        {
            case MY_PERMISSIONS_REQUEST_STORAGE:
                if(grantResults[0] == PackageManager.PERMISSION_GRANTED)
                {
                    resultStorage = true;
                }
                else
                {
                    resultStorage = false;
                    Toast.makeText(NewPlaceImageActivity.this, "Please provide permission to access your library", Toast.LENGTH_SHORT).show();
                }
                if((permissionAttempt == 2) && (resultStorage == true))
                {
                    Log.d(tag, "open gallery");
                }
                else
                {
                    Log.d(tag, "do nothing");
                }
                break;
        }
    }
}
