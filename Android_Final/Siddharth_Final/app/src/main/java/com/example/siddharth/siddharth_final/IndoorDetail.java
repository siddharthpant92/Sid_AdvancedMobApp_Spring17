package com.example.siddharth.siddharth_final;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class IndoorDetail extends Activity
{
    String tag = "IndoorDetail";
    String activity;

    TextView activtiyName;

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_indoor_detail);

        Bundle bundle = getIntent().getExtras();
        activity = bundle.getString("activity");

        activtiyName = (TextView) findViewById(R.id.activtiyName2);
        activtiyName.setText(activity);


    }

}
