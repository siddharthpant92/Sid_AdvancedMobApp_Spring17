package com.example.siddharth.globetrotter;

import android.content.Intent;
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

    DatabaseReference placeChild, notesChild;

    EditText placeName;
    EditText notes;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_place);

        placeName = (EditText) findViewById(R.id.placeName);
        notes = (EditText) findViewById(R.id.notes);

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

    public void extraNotesTapped(View view)
    {
        Intent intent = new Intent(NewPlaceActivity.this, NewPlaceExtraActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString("place", String.valueOf(placeName.getText()));
        bundle.putString("notes", String.valueOf(notes.getText()));
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
                    Toast.makeText(NewPlaceActivity.this, "Saved", Toast.LENGTH_SHORT).show();
                else
                    Toast.makeText(NewPlaceActivity.this, "Error! Are you connected to the internet?", Toast.LENGTH_SHORT).show();
            }
        });
    }
}
