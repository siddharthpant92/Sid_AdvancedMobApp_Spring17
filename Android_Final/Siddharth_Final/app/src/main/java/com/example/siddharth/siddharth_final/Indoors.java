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

public class Indoors extends Activity
{

    String tag = "Indoor";

    ListView indoorListView;

    List<String> indoorActivities = new ArrayList<String>();
    ArrayAdapter arrayAdapter;

    Button addIndoorActivity;

    String activityToBeDeleted;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_indoors);

        indoorListView = (ListView) findViewById(R.id.indoorListView);
        addIndoorActivity = (Button) findViewById(R.id.addIndoorActivity);

        registerForContextMenu(indoorListView);

        //Checking to see if user had previously saved any activities
        SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("IndoorAcitivities", Context.MODE_PRIVATE);

        Set<String> set = sharedPreferences.getStringSet("savedIndoorActivities", null);

        Log.d(tag, "fetching saved set: "+set);

        indoorActivities.clear();
        if(set != null)
        {
            for(String s: set)
            {
                //Getting new activites
                indoorActivities.add(s);
            }
        }
        else
        {
            for(int i = 0; i< Activities.indoorActivities.length; i++)
            {
                //Default 2 indoor activites which are in Activies.java
                indoorActivities.add(Activities.indoorActivities[i].toString());
            }
        }

        arrayAdapter = new ArrayAdapter(Indoors.this, android.R.layout.simple_list_item_1, indoorActivities);
        indoorListView.setAdapter(arrayAdapter);


        //Button to add new activity
        addIndoorActivity.setOnClickListener(new View.OnClickListener()
        {
            @Override
            public void onClick(View v)
            {
                add();
            }
        });


        //Going to indoor detail
        indoorListView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
                Intent intent  =  new Intent(Indoors.this, IndoorDetail.class);
                Bundle bundle = new Bundle();
                bundle.putString("activity", adapterView.getItemAtPosition(position).toString());
                intent.putExtras(bundle);
                startActivity(intent);
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
        final Dialog dialog = new Dialog(Indoors.this);
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
                    indoorActivities.add(newActivtityText);
                    arrayAdapter.notifyDataSetChanged();
                    dialog.dismiss();

                    saveActivity();
                }
                else
                    Toast.makeText(Indoors.this, "Enter an Anime!", Toast.LENGTH_SHORT).show();
            }
        });
        dialog.show();
    }


    //Saving activites
    public void saveActivity()
    {
        SharedPreferences sharedPreferences = getApplicationContext().getSharedPreferences("IndoorAcitivities", Context.MODE_PRIVATE);

        SharedPreferences.Editor editor = sharedPreferences.edit();

        Set<String> set = new HashSet<String>();
//        for(int i=0;i<animeList.size();i++)
//        {
//            Log.d(tag, "adding "+animeList.get(i));
//            set.add(animeList.get(i).toString());
//        }
        set.addAll(indoorActivities);
        editor.putStringSet("savedIndoorActivities", set);
        editor.commit();
        Log.d(tag, "finished saving: "+set);
    }



    //Context menu for deleting
    @Override
    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo)
    {
        super.onCreateContextMenu(menu, v, menuInfo);

        AdapterView.AdapterContextMenuInfo adapterContextMenuInfo = (AdapterView.AdapterContextMenuInfo) menuInfo;
        activityToBeDeleted = indoorActivities.get(adapterContextMenuInfo.position);
        menu.setHeaderTitle("Delete "+activityToBeDeleted+"?");
        menu.add(1, 1, 1, "Yes");
        menu.add(2, 2, 2, "No");
    }

    @Override
    public boolean onContextItemSelected(MenuItem item)
    {
        if(item.getItemId() == 1)
        {
            indoorActivities.remove(activityToBeDeleted);
            arrayAdapter.notifyDataSetChanged();
            saveActivity();
        }
        return true;
    }
}
