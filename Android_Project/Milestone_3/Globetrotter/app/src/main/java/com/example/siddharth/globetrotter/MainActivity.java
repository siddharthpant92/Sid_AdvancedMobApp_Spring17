package com.example.siddharth.globetrotter;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class MainActivity extends AppCompatActivity {

    ListView listView;
    String tag = "MainActivity";

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference myRef = database.getReference();

    String key, value;

    ArrayList<String> places = new ArrayList<String>();
    ArrayList<String> notes = new ArrayList<String>();
    ArrayList<String> extraNotes = new ArrayList<String>();
    ArrayList<String> path = new ArrayList<String>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = (ListView) findViewById(R.id.listView);

        String[] temp = new String[]{"a", "b", "c"};

        // Read from the database
        myRef.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                // This method is called once with the initial value and again
                // whenever data at this location is updated.
                for (DataSnapshot child : dataSnapshot.getChildren()) {
//                    for (DataSnapshot single : child.getChildren()) {
//                        Map<String, Object> map = (Map<String, Object>) single.getValue();
//                        String a = (String) map.get("notes");
//                        String b = (String) map.get("extraNotes");
//
//                        Log.d(tag, a);
//                        Log.d(tag, b);
//                    }
                    Log.d(tag, String.valueOf(child.getKey()));
                    Log.d(tag, String.valueOf(child.getValue()));
                }
            }

            @Override
            public void onCancelled(DatabaseError error) {
                // Failed to read value
                Log.d(tag, "Failed to read value.", error.toException());
            }
        });



        PlacesListView adapter = new PlacesListView(MainActivity.this, temp);
        listView.setAdapter(adapter);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener(){
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(MainActivity.this, NewPlaceActivity.class);
                startActivity(intent);
            }
        });
    }
}
