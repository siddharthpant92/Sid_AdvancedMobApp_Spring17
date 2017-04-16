package com.example.siddharth.globetrotter;

import android.*;
import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Camera;
import android.os.Build;
import android.support.v4.app.ActivityCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class NewPlaceExtraActivity extends AppCompatActivity {

    String tag = "NewPlaceExtra";

    private static final int MY_PERMISSIONS_REQUEST_CAMERA = 0;

    FirebaseDatabase database  = FirebaseDatabase.getInstance();
    DatabaseReference myRef = database.getReference();

    String place;

    EditText extraNotes;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_extra);

        Bundle bundle = getIntent().getExtras();
        place = bundle.getString("place");

        extraNotes = (EditText) findViewById(R.id.extraNotes);
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

    public void newPlaceImageTapped(View view)
    {
        boolean result = checkPermissionCamera();

        if(result)
        {
            goToNewPlaceImageActivity();
        }
    }

    public void goToNewPlaceImageActivity()
    {
        Intent intent = new Intent(NewPlaceExtraActivity.this, NewPlaceImageActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString("place", place);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    public void saveData()
    {
        DatabaseReference mainChild = myRef.child(place);
        DatabaseReference child2 = mainChild.child("extraNotes");
        child2.setValue(String.valueOf(extraNotes.getText()));
    }

    public boolean checkPermissionCamera()
    {
        if(Build.VERSION.SDK_INT >= 23)
        {
            if(checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
            {
                requestPermissions(new String[]{Manifest.permission.CAMERA}, MY_PERMISSIONS_REQUEST_CAMERA);
                return false;
            }
            else
            {
                return  true;
            }
        }
        else
        {
            return  true;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults)
    {
       switch (requestCode)
        {
            case MY_PERMISSIONS_REQUEST_CAMERA:
                if(grantResults[0] == PackageManager.PERMISSION_GRANTED)
                {
                    goToNewPlaceImageActivity();
                }
                else
                {
                    Toast.makeText(NewPlaceExtraActivity.this, "Please provide camera access to take a picture", Toast.LENGTH_SHORT).show();
                }
                break;
        }
    }
}
