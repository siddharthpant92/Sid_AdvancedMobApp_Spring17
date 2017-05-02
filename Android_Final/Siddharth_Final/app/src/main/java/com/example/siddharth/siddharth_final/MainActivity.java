package com.example.siddharth.siddharth_final;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class MainActivity extends Activity
{
    String tag = "MainActivity";

    ListView listView;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        listView = (ListView) findViewById(R.id.listView);

        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
                String activityType = (String) adapterView.getItemAtPosition(position);
                if(activityType.equals("Indoors"))
                {
                    Intent intent = new Intent(MainActivity.this, Indoors.class);
                    startActivity(intent);
                }
                else
                {
                    Intent intent = new Intent(MainActivity.this, Outdoors.class);
                    startActivity(intent);
                }
            }
        });
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item)
    {
        switch (item.getItemId())
        {
            case(R.id.event):
                Intent intent = new Intent(MainActivity.this, SignUp.class);
                startActivity(intent);
                break;
            default:
                super.onOptionsItemSelected(item);
                break;
        }
        return true;
    }
}
