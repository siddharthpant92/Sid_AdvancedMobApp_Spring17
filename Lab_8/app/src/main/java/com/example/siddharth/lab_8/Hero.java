package com.example.siddharth.lab_8;

import android.content.Context;
import android.content.SharedPreferences;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * Created by sid on 4/23/17.
 */

public class Hero
{
    private String universe;
    private ArrayList<String> superheroes = new ArrayList<>();

    public Hero(String universe, ArrayList<String> superheroes)
    {
        this.universe = universe;
        this.superheroes = superheroes;
    }

    public static final Hero[] heroes = {
            new Hero(("DC"), new ArrayList<String>()),
            new Hero("Marvel", new ArrayList<String>())
    };

    public String getUniverse()
    {
        return universe;
    }

    public ArrayList<String> getSuperheroes()
    {
        return superheroes;
    }

    public String toString()
    {
        return this.universe;
    }

    public void storeHeroes(Context context, int universeId)
    {
        SharedPreferences sharedPrefs = context.getSharedPreferences("Superheroes", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        Set<String> set = new HashSet<String>();
        set.addAll(heroes[(int) universeId].getSuperheroes());
        editor.putStringSet(heroes[(int) universeId].getUniverse(), set);
        editor.commit();
    }

    public void loadHeroes(Context context, int universeId)
    {
        SharedPreferences sharedPrefs = context.getSharedPreferences("Superheroes", Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        Set<String> set =sharedPrefs.getStringSet(heroes[universeId].getUniverse(), null);

        //if there was a saved list add it to the heroes array
        if (set != null)
        {
            Hero.heroes[universeId].superheroes.addAll(set);
        }
        //if no hero list was saved, use the defaults
        else
        {
            switch (universeId)
            {
                case 0:
                    Hero.heroes[0].superheroes.addAll(Arrays.asList("Superman", "Batman"));
                    break;
                case 1:
                    Hero.heroes[1].superheroes.addAll(Arrays.asList("Iron Man", "Black Panther","Hulk"));
                    break;
                default:
                    break;
            }
        }
    }
}
