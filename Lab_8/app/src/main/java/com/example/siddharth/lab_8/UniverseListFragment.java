package com.example.siddharth.lab_8;


import android.content.Context;
import android.os.Bundle;
import android.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;


/**
 * A simple {@link Fragment} subclass.
 */
public class UniverseListFragment extends Fragment implements AdapterView.OnItemClickListener
{
    UniverseListListener listener; //listener for the interface method

   public UniverseListFragment()
    {
        // Required empty public constructor
    }


    @Override
    //Called each time Android needs the fragment’s layout
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_universe_list, container, false);
    }

    @Override
    //Everytime the fragment is visible
    public void onStart()
    {
        super.onStart();

        View view = getView();
        if(view != null)
        {
            ListView listUniverse = (ListView) view.findViewById(R.id.listView);
            ArrayAdapter<Hero> listAdapter = new ArrayAdapter<Hero>(getActivity(), android.R.layout.simple_list_item_1, Hero.heroes);
            listUniverse.setAdapter(listAdapter);

            //attach the listener to the listview
            listUniverse.setOnItemClickListener(this);
        }
    }

    @Override
    public void onAttach(Context context)
    {
        super.onAttach(context);

        //attaches the context to the listener
        listener = (UniverseListListener) context;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id)
    {
        if(listener != null)
        {
            listener.itemClicked((int) id); //Calling the method of the interface which is implementd in MainActivity.
        }
    }

    interface UniverseListListener
    {
        void itemClicked(int id);
        //We don't know whether HeroDetailFragment will be part of MainActivity or DetailActivity.
        // So we implement the interface so that MainActivity can decide using different layout files.
    }


}
