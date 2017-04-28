package com.example.siddharth.lab_8;

import android.app.Activity;
import android.app.FragmentTransaction;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

public class MainActivity extends Activity implements UniverseListFragment.UniverseListListener, HeroDetailFragment.ButtonClickListener
{

    String tag = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    @Override
    public void itemClicked(int id)
    {
        View fragmentContainer = findViewById(R.id.fragment_container);
        if (fragmentContainer != null)
        {
            HeroDetailFragment frag = new HeroDetailFragment();
            FragmentTransaction ft = getFragmentManager().beginTransaction();
            frag.setUniverseId(id);
            ft.replace(R.id.fragment_container, frag);
            ft.addToBackStack(null);
            ft.setTransition(FragmentTransaction.TRANSIT_FRAGMENT_FADE);
            ft.commit();
        }
        else
        {   //app is running on a device with a smaller screen
            Intent intent = new Intent(this, DetailActivity.class);
            intent.putExtra("id", id);
            startActivity(intent);
        }
    }

    @Override
    public void onBackPressed()
    {
        if(getFragmentManager().getBackStackEntryCount() > 0)
        {
            getFragmentManager().popBackStack();
        }
        else
        {
            super.onBackPressed();
        }
    }

    @Override
    public void addHeroClicked(View view)
    {
        Log.d(tag, "addHeroClicked, MainActivtity");
        HeroDetailFragment fragment = (HeroDetailFragment) getFragmentManager().findFragmentById(R.id.fragment_container);
        fragment.addHero();
    }
}
