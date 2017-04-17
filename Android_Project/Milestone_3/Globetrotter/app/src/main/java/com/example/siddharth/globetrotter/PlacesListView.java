package com.example.siddharth.globetrotter;

import android.app.Activity;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.view.LayoutInflater;
import android.widget.TextView;

import java.util.ArrayList;

public class PlacesListView extends ArrayAdapter<String> {

    private Activity context;
    String tag = "PlacesListView";
    ArrayList<String> places = new ArrayList<String>();

    TextView placeName;

    public PlacesListView(Activity context, ArrayList<String> places) {
        super(context, R.layout.activity_places_list_view, places);
        this.context = context;
        this.places = places;
    }

    //MARK: CREATING AND DISPLAYING VIEW
    public View getView(final int position, View view, ViewGroup parent)
    {
        LayoutInflater inflater = context.getLayoutInflater();
        View rowView=inflater.inflate(R.layout.activity_places_list_view, null,true);

        placeName = (TextView) rowView.findViewById(R.id.placeName);
        placeName.setText(places.get(position));

        return rowView;
    };


}

