package com.example.siddharth.siddharth_final;

import android.app.Activity;
import android.os.Bundle;

public class SignUp extends Activity
{
    String tag = "SignUp";

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        getActionBar().setDisplayHomeAsUpEnabled(true);
    }
}
