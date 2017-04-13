package com.example.siddharth.lab_7;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

public class TeamPosition extends Activity {

    String tag = "TeamPosition";
    String team;
    String playingPosition;

    ListView positionListView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_team_position);

        Intent intent = getIntent();
        team = intent.getStringExtra("team");

        positionListView = (ListView) findViewById(R.id.positionListView);

        AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener()
        {
            @Override
            public void onItemClick(AdapterView<?> adapterView, View view, int position, long id)
            {
                playingPosition = (String) adapterView.getItemAtPosition(position);

                Intent intent1 = new Intent(TeamPosition.this, TeamPositionPlayer.class);
                intent1.putExtra("team", team);
                intent1.putExtra("playingPosition", playingPosition);
                startActivity(intent1);
            }
        };
        positionListView.setOnItemClickListener(itemClickListener);
    }

}
