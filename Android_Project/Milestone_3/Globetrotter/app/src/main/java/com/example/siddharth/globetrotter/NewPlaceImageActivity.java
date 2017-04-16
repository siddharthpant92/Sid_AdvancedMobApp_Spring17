package com.example.siddharth.globetrotter;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.io.File;

public class NewPlaceImageActivity extends AppCompatActivity {

    String tag = "NewPlaceImageActivity";

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference myRef = database.getReference();

    private static final int MY_PERMISSIONS_REQUEST_STORAGE = 0;
    static final Integer PICK_IMAGE = 100;
    boolean resultStorage; //To store result of external storage permission
    int permissionAttempt; //User has 2 attempts to grant permission

    String place;
    String imagePath;
    ImageView imageView;
    TextView loadingLabel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_image);

        imageView = (ImageView) findViewById(R.id.placeImage);
        loadingLabel = (TextView) findViewById(R.id.loadingLabel);

        loadingLabel.setVisibility(View.VISIBLE);

        Bundle bundle = getIntent().getExtras();
        place = bundle.getString("place");

        permissionAttempt = 1; //First time user is asked for permission
        checkPermissionStorage();
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
                saveData();
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
            openGallery();
        }
    }


    public void saveData()
    {
        DatabaseReference mainChild = myRef.child(place);
        DatabaseReference child3 = mainChild.child("image");
        child3.setValue(imagePath);
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
                    openGallery();
                }
                else
                {
                    Log.d(tag, "do nothing");
                }
                break;
        }
    }

    public void openGallery()
    {
        Intent gallery = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI);
        startActivityForResult(gallery, PICK_IMAGE );
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data)
    {
        super.onActivityResult(requestCode, resultCode, data);

        if((resultCode == RESULT_OK) && (requestCode == PICK_IMAGE))
        {
            Uri imageUri = data.getData();
            Glide.with(NewPlaceImageActivity.this)
                    .load(imageUri)
                    .into(imageView);

            loadingLabel.setVisibility(View.INVISIBLE);

            imagePath = getRealPath(imageUri);
        }
    }

    public String getRealPath(Uri uri)
    {
        Cursor cursor = getContentResolver().query(uri, null, null, null, null);
        cursor.moveToFirst();
        int idx = cursor.getColumnIndex(MediaStore.Images.ImageColumns.DATA);

        return cursor.getString(idx);
    }
}
