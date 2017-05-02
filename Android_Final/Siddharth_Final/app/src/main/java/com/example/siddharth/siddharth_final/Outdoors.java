package com.example.siddharth.siddharth_final;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Outdoors extends Activity
{

    String tag = "Outdoor";

    ListView outdoorListView;

    List<String> outdoorActivities = new ArrayList<String>();
    ArrayAdapter arrayAdapter;

    Button addOutdoorActivity;

    String activityToBeDeleted;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_outdoors);


        outdoorListView = (ListView) findViewById(R.id.outdoorListView);
        addOutdoorActivity = (Button) findViewById(R.id.addOutdoorActivity);

        registerForContextMenu(outdoorListView);

        //Checking to see if user had previously saved any activities
        SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("OutdoorAcitivities", Context.MODE_PRIVATE);

        Set<String> set = sharedPreferences.getStringSet("savedOutdoorActivities", null);

        Log.d(tag, "fetching saved set: "+set);

        outdoorActivities.clear();
        if(set != null)
        {
            for(String s: set)
            {
                //Getting new activites
                outdoorActivities.add(s);
            }
        }
        else
        {
            for(int i = 0; i< Activities.outdoorActivities.length; i++)
            {
                //Default 2 outdoor activites which are in Activies.java
                outdoorActivities.add(Activities.outdoorActivities[i].toString());
            }
        }

        arrayAdapter = new ArrayAdapter(Outdoors.this, android.R.layout.simple_list_item_1, outdoorActivities);
        outdoorListView.setAdapter(arrayAdapter);


        //Going to outdoor detail
        outdoorListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
                Log.d(tag, "tapped");
                Intent intent  =  new Intent(Outdoors.this, OutdoorDetail.class);
                Bundle bundle = new Bundle();
                bundle.putString("activity", adapterView.getItemAtPosition(position).toString());
                intent.putExtras(bundle);
                startActivity(intent);
            }
        });

        addOutdoorActivity.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                add();
            }
        });

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu)
    {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {
            case(R.id.event):
//                Intent intent = new Intent(IndoorDetail.this, SignUp.class);
//                startActivity(intent);
                Log.d(tag, "tapped");
                break;
            default:
                super.onOptionsItemSelected(item);
                break;
        }
        return true;
    }

    public void add()
    {
        //Adding new activity
        final Dialog dialog = new Dialog(Outdoors.this);
        dialog.setContentView(R.layout.dialog);

        dialog.setTitle("Add your new activity!");

        Button addNewActivtiy = (Button) dialog.findViewById(R.id.addNewActivtiy);
        addNewActivtiy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                EditText newActivtity = (EditText) dialog.findViewById(R.id.newActivtity);
                String newActivtityText = newActivtity.getText().toString();
                if(newActivtityText.length() > 0)
                {
                    //String newAnimeName = new Anime(newAnimeText);
                    outdoorActivities.add(newActivtityText);
                    arrayAdapter.notifyDataSetChanged();
                    dialog.dismiss();

                    saveActivity();
                }
                else
                    Toast.makeText(Outdoors.this, "Enter an Anime!", Toast.LENGTH_SHORT).show();
            }
        });
        dialog.show();
    }


    //Saving activites
    public void saveActivity()
    {
        SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("OutdoorAcitivities", Context.MODE_PRIVATE);

        SharedPreferences.Editor editor = sharedPreferences.edit();

        Set<String> set = new HashSet<String>();
//        for(int i=0;i<animeList.size();i++)
//        {
//            Log.d(tag, "adding "+animeList.get(i));
//            set.add(animeList.get(i).toString());
//        }
        set.addAll(outdoorActivities);
        editor.putStringSet("savedOutdoorActivities", set);
        editor.commit();
        Log.d(tag, "finished saving: "+set);
    }



    //Context menu for deleting
    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo)
    {
        super.onCreateContextMenu(menu, v, menuInfo);

        AdapterView.AdapterContextMenuInfo adapterContextMenuInfo = (AdapterView.AdapterContextMenuInfo) menuInfo;
        activityToBeDeleted = outdoorActivities.get(adapterContextMenuInfo.position);
        menu.setHeaderTitle("Delete "+activityToBeDeleted+"?");
        menu.add(1, 1, 1, "Yes");
        menu.add(2, 2, 2, "No");
    }

    @Override
    public boolean onContextItemSelected(MenuItem item)
    {
        if(item.getItemId() == 1)
        {
            outdoorActivities.remove(activityToBeDeleted);
            arrayAdapter.notifyDataSetChanged();
            saveActivity();
        }
        return true;
    }
}
