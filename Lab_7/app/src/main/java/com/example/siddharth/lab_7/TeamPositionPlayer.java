package com.example.siddharth.lab_7;

import android.app.Activity;
import android.app.ListActivity;
import android.content.Intent;
import android.os.Bundle;
import android.widget.ArrayAdapter;
import android.widget.ListView;

public class TeamPositionPlayer extends ListActivity {

    String tag = "TeamPositionPlayer";
    String team;
    String playingPosition;

    String[] manchesterUnitedForwards = new String[]{"Zlatan", "Rashford", "Martial"};
    String[] manchesterUnitedMidfielders = new String[]{"Mikhitaryan", "Pogba", "Carrick"};
    String[] manchesterUnitedDefenders = new String[]{"Bailey", "Valencia"};
    String[] manchesterUnitedGoalkeepers = new String[]{"De gea", "Romero"};

    String[] ChelseaForwards = new String[]{"Costa"};
    String[] ChelseaMidfielders = new String[]{"Hazard", "Fabregas"};
    String[] ChelseaDefenders = new String[]{"Luiz"};
    String[] ChelseaGoalkeepers = new String[]{"Curtois"};

    String[] RealMadridForwards = new String[]{"Benzema"};
    String[] RealMadridMidfielders = new String[]{"Ronaldo", "Bale", "Kroos"};
    String[] RealMadridDefenders = new String[]{"Ramos", "Carvajal", "Marcelo"};
    String[] RealMadridGoalkeepers = new String[]{"Bravo"};


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        getActionBar().setDisplayHomeAsUpEnabled(true);

        Intent intent = getIntent();
        team = intent.getStringExtra("team");
        playingPosition = intent.getStringExtra("playingPosition");

        ListView listView = getListView();
        ArrayAdapter<String> arrayAdapter = null;

        if(team.equals("Manchester United"))
        {
            if(playingPosition.equals("Forwards"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, manchesterUnitedForwards);
            }
            else if(playingPosition.equals("Midfielders"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, manchesterUnitedMidfielders);
            }
            else if(playingPosition.equals("Defenders"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, manchesterUnitedDefenders);
            }
            else if(playingPosition.equals("Goalkeepers"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, manchesterUnitedGoalkeepers);
            }
        }
        else if(team.equals("Real Madrid"))
        {
            if(playingPosition.equals("Forwards"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, RealMadridForwards);
            }
            else if(playingPosition.equals("Midfielders"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, RealMadridMidfielders);
            }
            else if(playingPosition.equals("Defenders"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, RealMadridDefenders);
            }
            else if(playingPosition.equals("Goalkeepers"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, RealMadridGoalkeepers);
            }
        }
        else if(team.equals("Chelsea"))
        {
            if(playingPosition.equals("Forwards"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, ChelseaForwards);
            }
            else if(playingPosition.equals("Midfielders"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, ChelseaMidfielders);
            }
            else if(playingPosition.equals("Defenders"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, ChelseaDefenders);
            }
            else if(playingPosition.equals("Goalkeepers"))
            {
                arrayAdapter = new ArrayAdapter<String>(TeamPositionPlayer.this, android.R.layout.simple_expandable_list_item_1, ChelseaGoalkeepers);
            }
        }
        listView.setAdapter(arrayAdapter);
    }
}
