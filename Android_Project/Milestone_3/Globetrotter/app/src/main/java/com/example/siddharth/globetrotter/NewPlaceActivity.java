package com.example.siddharth.globetrotter;

import android.app.ActionBar;
import android.content.Intent;
import android.os.Handler;
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

public class NewPlaceActivity extends AppCompatActivity {

    String tag = "NewPlaceAcitvity";

    FirebaseDatabase database  = FirebaseDatabase.getInstance();
    DatabaseReference myRef = database.getReference();

    DatabaseReference placeChild, notesChild, extraNotesChild, imagePathChild;

    EditText placeName, notes;

    String type; //Indicates whether it's a new or existing place;
    String placeValue, extraNotesValue, imageValue, notesValue; //The original stored values

    boolean notesSaved, extraNotesSaved, imagePathSaved;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place);

        placeName = (EditText) findViewById(R.id.placeName);
        notes = (EditText) findViewById(R.id.notes);

        Bundle bundle = getIntent().getExtras();
        type = bundle.getString("type");
        if(type.equals("existing"))
        {
            placeValue = bundle.getString("placeValue");
            extraNotesValue = bundle.getString("extraNotesValue");
            imageValue = bundle.getString("imageValue");
            notesValue = bundle.getString("notesValue");

            placeName.setText(placeValue);
            notes.setText(notesValue);
        }
        else
        {
            notesValue = "";
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

    public void extraNotesTapped(View view)
    {
        Intent intent = new Intent(NewPlaceActivity.this, NewPlaceExtraActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString("place", String.valueOf(placeName.getText()));
        bundle.putString("notes", String.valueOf(notes.getText()));

        if(type.equals("existing")) //if the user selected an existing place, then we have to pass
        // on the original values
        {
            bundle.putString("type", type);
            bundle.putString("extraNotesValue", extraNotesValue);
            bundle.putString("imageValue", imageValue);
        }
        bundle.putString("type", type);
        intent.putExtras(bundle);
        startActivity(intent);
    }

    public void saveData()
    {
        //Setting root child and first child values
        placeChild =  myRef.child(String.valueOf(placeName.getText()));

        notesChild = placeChild.child("notes");
        notesChild.setValue(String.valueOf(notes.getText()), new DatabaseReference.CompletionListener()
        {
            @Override
            public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference)
            {
                if(databaseError == null)
                    notesSaved = true;
                else
                    Toast.makeText(NewPlaceActivity.this, "Your notes didn't save! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        });


        //Saving extra notes
        extraNotesChild = placeChild.child("extraNotes");
        extraNotesChild.setValue(extraNotesValue, new DatabaseReference.CompletionListener() {
            @Override
            public void onComplete(DatabaseError databaseError, DatabaseReference databaseReference) {
                if(databaseError == null)
                    extraNotesSaved = true;
                else
                    Toast.makeText(NewPlaceActivity.this, "Your notes didn't save! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
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
                    Toast.makeText(NewPlaceActivity.this, "Your image didn't save! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        });

        //Toast.makeText(NewPlaceActivity.this, "Saved", Toast.LENGTH_SHORT).show();

        Handler handler = new Handler();
        handler.postDelayed(new Runnable()
        {
            @Override
            public void run()
            {
                Log.d(tag, "notesChild = "+notesSaved);
                Log.d(tag, "extranotesChild = "+extraNotesSaved);
                Log.d(tag, "image = "+imagePathSaved);

                //Displaying successful save toast
                if((notesSaved == true) && (extraNotesSaved == true) && (imagePathSaved == true))
                    Toast.makeText(NewPlaceActivity.this, "Saved", Toast.LENGTH_SHORT).show();
                else
                    Toast.makeText(NewPlaceActivity.this, "Error! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        }, 3000);
    }
}
