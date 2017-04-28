package com.example.siddharth.lab_8;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

public class DetailActivity extends Activity implements HeroDetailFragment.ButtonClickListener
{
    String tag = "DetailActitvity";

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);

        HeroDetailFragment heroDetailFragment = (HeroDetailFragment) getFragmentManager().findFragmentById(R.id.fragment_container);
        int universeId = (int) getIntent().getExtras().get("id");
        //Log.d(tag, String.valueOf(universeId));
        heroDetailFragment.setUniverseId(universeId);

    }

    @Override
    public void addHeroClicked(View view)
    {
        Log.d(tag, "addHeroClicked, DetailActivity");
        HeroDetailFragment fragment = (HeroDetailFragment) getFragmentManager().findFragmentById(R.id.fragment_container);
        fragment.addHero();
    }
}
