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

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

public class NewPlaceExtraActivity extends AppCompatActivity {

    String tag = "NewPlaceExtra";

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
        Intent intent = new Intent(NewPlaceExtraActivity.this, NewPlaceImageActivity.class);
        startActivity(intent);
    }

    public void saveData()
    {
        DatabaseReference mainChild = myRef.child(place);
        DatabaseReference child2 = mainChild.child("extraNotes");
        child2.setValue(String.valueOf(extraNotes.getText()));
    }
}
