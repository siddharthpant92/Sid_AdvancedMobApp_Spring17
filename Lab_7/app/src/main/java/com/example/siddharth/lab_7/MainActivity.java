package com.example.siddharth.lab_7;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class MainActivity extends Activity {
    ListView teamListView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        teamListView = (ListView) findViewById(R.id.teamListView);

        AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id)
            {
                String team = (String) adapterView.getItemAtPosition(position);

                Intent intent = new Intent(MainActivity.this, TeamPosition.class);
                intent.putExtra("team", team);
                startActivity(intent);
            }
        };
        teamListView.setOnItemClickListener(itemClickListener);
    }
}
