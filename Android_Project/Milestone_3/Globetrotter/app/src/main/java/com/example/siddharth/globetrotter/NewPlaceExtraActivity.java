package com.example.siddharth.globetrotter;

import android.*;
import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Camera;
import android.os.Build;
import android.os.Handler;
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

import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class NewPlaceExtraActivity extends AppCompatActivity {

    String tag = "NewPlaceExtra";

    private static final int MY_PERMISSIONS_REQUEST_CAMERA = 0;

    FirebaseDatabase database  = FirebaseDatabase.getInstance();
    DatabaseReference myRef = database.getReference();

    DatabaseReference placeChild, notesChild, extraNotesChild, imagePathChild;

    String place, notes; //The values displayed in NewPlaceActivity
    String type, imageValue, extraNotesValue; //The original stored values
    EditText extraNotes;

    boolean notesSaved, extraNotesSaved, imagePathSaved;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place_extra);

        extraNotes = (EditText) findViewById(R.id.extraNotes);

        Bundle bundle = getIntent().getExtras();
        place = bundle.getString("place");
        notes = bundle.getString("notes");
        type = bundle.getString("type");
        if(type.equals("existing"))
        {
            extraNotesValue = bundle.getString("extraNotesValue");
            imageValue = bundle.getString("imageValue");

            extraNotes.setText(extraNotesValue);
        }
        else
        {
            extraNotesValue = "";
            imageValue = "";
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {

        MenuInflater menuInflater = getMenuInflater();
        menuInflater.inflate(R.menu.menu_main, menu);

        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        int itemId = item.getItemId();
        switch (itemId)
        {
            case (R.id.save):
                saveData();
        }
        return super.onOptionsItemSelected(item);
    }

    public void newPlaceImageTapped(View view)
    {
        boolean resultCamera = checkPermissionCamera(); //False the first time user taps as the user still has to grant permission

        if(resultCamera)  //True only from the seconds time user taps this because user has already given permission
        {
            goToNewPlaceImageActivity();
        }
    }

    public void goToNewPlaceImageActivity()
    {
        Intent intent = new Intent(NewPlaceExtraActivity.this, NewPlaceImageActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString("place", place);
        bundle.putString("notes", notes);
        bundle.putString("extraNotes", String.valueOf(extraNotes.getText()));
        if(type.equals("existing"))
        {
            bundle.putString("imageValue", imageValue);
        }
        bundle.putString("type", type);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    public void saveData()
    {
        placeChild = myRef.child(place);

        //Saving notes
        notesChild = placeChild.child("notes");
        notesChild.setValue(notes, new DatabaseReference.CompletionListener() {
            @Override
            public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                if(databaseError == null)
                    notesSaved = true;
                else
                    Toast.makeText(NewPlaceExtraActivity.this, "Your notes didn't save! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        });


        //Saving extra notes
        extraNotesChild = placeChild.child("extraNotes");
        extraNotesChild.setValue(String.valueOf(extraNotes.getText()), new DatabaseReference.CompletionListener() {
            @Override
            public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                if(databaseError == null)
                    extraNotesSaved = true;
                else
                    Toast.makeText(NewPlaceExtraActivity.this, "Your extra notes didn't save! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        });


        //Saving image Path
        imagePathChild = placeChild.child("image");
        imagePathChild.setValue(imageValue, new DatabaseReference.CompletionListener() {
            @Override
            public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                if(databaseError == null)
                    imagePathSaved = true;
                else
                    Toast.makeText(NewPlaceExtraActivity.this, "Your image didn't save! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        });

        Toast.makeText(NewPlaceExtraActivity.this, "Saved", Toast.LENGTH_SHORT).show();

//        Handler handler = new Handler();
//        handler.postDelayed(new Runnable()
//        {
//            @Override
//            public void run()
//            {
//                Log.d(tag, "notesChild = "+notesSaved);
//                Log.d(tag, "extranotesChild = "+extraNotesSaved);
//                Log.d(tag, "image = "+imagePathSaved);
//
//                //Displaying successful saved toast
//                if((notesSaved == true) && (extraNotesSaved == true) &&(imagePathSaved == true))
//                    Toast.makeText(NewPlaceExtraActivity.this, "Saved", Toast.LENGTH_SHORT).show();
//                else
//                    Toast.makeText(NewPlaceExtraActivity.this, "Error!", Toast.LENGTH_SHORT).show();
//            }
//        }, 2000);
    }

    public boolean checkPermissionCamera()
    {
        if(Build.VERSION.SDK_INT >= 23)
        {
            if(checkSelfPermission(Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED)
            {
                //User is asked for permission the first time
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
                    goToNewPlaceImageActivity(); //The first time user grants permission.
                }
                else
                {
                    Toast.makeText(NewPlaceExtraActivity.this, "Please provide camera access to take a picture", Toast.LENGTH_SHORT).show();
                }
                break;
        }
    }
}
