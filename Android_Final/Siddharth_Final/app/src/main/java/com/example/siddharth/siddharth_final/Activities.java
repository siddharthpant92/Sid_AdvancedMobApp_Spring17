package com.example.siddharth.siddharth_final;

import android.app.Activity;

/**
 * Created by sid on 5/2/17.
 */

public class Activities
{
    private String name;

    public Activities(String newName)
    {
        this.name = newName;
    }


    public static final Activities[] indoorActivities = new Activities[]{
            new Activities("Swimming"),
            new Activities("BasketBall")
    };

    public static final Activities[] outdoorActivities = new Activities[]{
            new Activities("Hiking"),
            new Activities("Cycling")
    };

    public String getName()
    {
        return name;
    }

    public String toString()
    {
        return  this.name;
    }

}
