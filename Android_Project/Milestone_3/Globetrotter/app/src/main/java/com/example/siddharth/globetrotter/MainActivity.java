package com.example.siddharth.globetrotter;

import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;

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

    DatabaseReference placeChild;

    ArrayList<String> places = new ArrayList<String>();
    ArrayList<String> placeChildren = new ArrayList<String>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = (ListView) findViewById(R.id.listView);
    }

    @Override
    public void onStart()
    {
        super.onStart();

        // Read from the database
        myRef.addValueEventListener(new ValueEventListener()
        {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot)
            {
                places.clear();//Otherwise on every change values are appended
                for (DataSnapshot child : dataSnapshot.getChildren())
                {
                    places.add(child.getKey());
                }

                PlacesListView adapter = new PlacesListView(MainActivity.this, places);
                listView.setAdapter(adapter);
            }

            @Override
            public void onCancelled(DatabaseError error) {
                // Failed to read value
                Log.d(tag, "Failed to read value.", error.toException());
            }
        });


        listView.setOnItemClickListener(new AdapterView.OnItemClickListener(){
            @Override
            public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                placeChild = myRef.child(places.get(position));
                placeChild.addValueEventListener(new ValueEventListener()
                {
                    @Override
                    public void onDataChange(DataSnapshot dataSnapshot)
                    {
                        //Getting all the children  values of (key, value) for that place
                        for(DataSnapshot child : dataSnapshot.getChildren())
                        {
                            placeChildren.add(String.valueOf(child.getValue()));
                        }
                    }

                    @Override
                    public void onCancelled(DatabaseError error) {
                        // Failed to read value
                        Log.d(tag, "Failed to read value: ", error.toException());
                    }
                });

                Handler handler = new Handler();
                handler.postDelayed(new Runnable()
                {
                    @Override
                    public void run()
                    {
                        //Getting all the values so that we can send it to next activity
                        String placeValue = places.get(position);
                        String extraNotesValue = placeChildren.get(0);
                        String imageValue = placeChildren.get(1);
                        String notesValue = placeChildren.get(2);

                        Intent intent = new Intent(MainActivity.this, NewPlaceActivity.class);
                        Bundle bundle = new Bundle();
                        bundle.putString("placeValue", placeValue);
                        bundle.putString("extraNotesValue", extraNotesValue);
                        bundle.putString("imageValue", imageValue);
                        bundle.putString("notesValue", notesValue);
                        startActivity(intent);
                    }
                }, 1000);
            }//End of onItemClick
        });//End of itemClickListener
    } //End of onStart
}
