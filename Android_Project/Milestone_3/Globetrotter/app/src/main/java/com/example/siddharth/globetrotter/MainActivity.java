package com.example.siddharth.globetrotter;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
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
    PlacesListView adapter;

    FirebaseDatabase database = FirebaseDatabase.getInstance();
    DatabaseReference myRef = database.getReference();

    DatabaseReference placeChild;

    ArrayList<String> places = new ArrayList<String>();
    ArrayList<String> placeChildren = new ArrayList<String>();

    String placeValue, extraNotesValue, imageValue, notesValue; //To get the original stored values

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = (ListView) findViewById(R.id.listView);

        registerForContextMenu(listView);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        MenuInflater menuInflater = getMenuInflater();
        menuInflater.inflate(R.menu.add_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        int itemId = item.getItemId();
        switch (itemId)
        {
            case R.id.addPlace:
                sendData("new");
                break;
        }
        return super.onOptionsItemSelected(item);
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

                adapter = new PlacesListView(MainActivity.this, places);
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
                placeChildren.clear(); //To clear and then repopulate the values.
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
                        placeValue = places.get(position);
                        //Getting all the values so that we can send it to next activity
                        extraNotesValue = placeChildren.get(0);
                        imageValue = placeChildren.get(1);
                        notesValue = placeChildren.get(2);
                        sendData("existing");
                    }
                }, 2000);
            }//End of onItemClick
        });//End of itemClickListener
    } //End of onStart


    //Deleting a place
    @Override
    public void onCreateContextMenu(ContextMenu menu, View view, ContextMenu.ContextMenuInfo menuInfo)
    {
        super.onCreateContextMenu(menu, view, menuInfo);

        AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) menuInfo;

        menu.setHeaderTitle("Are you sure you want to delete "+places.get(info.position)+"?");
        menu.add(1, 1, 1, "Yes");
        menu.add(2, 2, 2, "No");
    }

    @Override
    public boolean onContextItemSelected(MenuItem item)
    {
        super.onContextItemSelected(item);

        if(item.getItemId() == 1)
        {
            AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();

            myRef.child(places.get(info.position)).removeValue(); //Deleting from the database

            //places.remove(placeDeleted);
            //adapter.notifyDataSetChanged();
        }
        return true;
    }


    public void sendData(String type)
    {
        Intent intent = new Intent(MainActivity.this, NewPlaceActivity.class);
        Bundle bundle = new Bundle();
        bundle.putString("type", type);
        if(type.equals("existing"))
        {
            bundle.putString("placeValue", placeValue);
            bundle.putString("extraNotesValue", extraNotesValue);
            bundle.putString("imageValue", imageValue);
            bundle.putString("notesValue", notesValue);

        }
        intent.putExtras(bundle);
        //Log.d(tag, String.valueOf(bundle));
        startActivity(intent);
    }
}
