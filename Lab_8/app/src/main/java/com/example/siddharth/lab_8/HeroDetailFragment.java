package com.example.siddharth.lab_8;


import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.app.Fragment;
import android.util.Log;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;

import java.util.ArrayList;


/**
 * A simple {@link Fragment} subclass.
 */
public class HeroDetailFragment extends Fragment implements View.OnClickListener
//It's View and not Adapter View as we are setting the listener on a button view
{
    String tag = "HeroDetailFragment";
    int universeId;
    ButtonClickListener listener;

    private ArrayAdapter<String> adapter;

    public HeroDetailFragment()
    {
        // Required empty public constructor
    }

    public void setUniverseId(int id)
    {
        this.universeId = id;
        Log.d(tag, String.valueOf(universeId));
    }

    //Saving instance state on rotation
    @Override
    public void onSaveInstanceState(Bundle savedInstanceState)
    {
        savedInstanceState.putInt("universeId", universeId);
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
    {
        if(savedInstanceState != null)
        {
            universeId = savedInstanceState.getInt("universeId");
        }

        //if the hero list is empty, load heroes. Size is 0 when user has deleted all heroes.
        // So the standard ones are loaded again
        if (Hero.heroes[0].getSuperheroes().size() == 0 )
        {
            Hero.heroes[0].loadHeroes(getActivity(), 0);
        }
        if (Hero.heroes[1].getSuperheroes().size() == 0 )
        {
            Hero.heroes[1].loadHeroes(getActivity(), 1);
        }

        // Inflate the layout for this fragment
        return inflater.inflate(R.layout.fragment_hero_detail, container, false);
    }

    @Override
    public void onStart()
    {
        super.onStart();

        View view = getView();


        ArrayList<String> heroList = Hero.heroes[universeId].getSuperheroes();

        ListView listHeroes = (ListView) view.findViewById(R.id.herolistView);
        adapter = new ArrayAdapter<String>(getActivity(), android.R.layout.simple_list_item_1, heroList);
        listHeroes.setAdapter(adapter);

        Button addButton = (Button) view.findViewById(R.id.addButton);
        addButton.setOnClickListener(this);

        registerForContextMenu(listHeroes);
    }

    @Override
    public void onAttach(Context context)
    {
        super.onAttach(context);

        //attaches the context to the listener
        listener = (HeroDetailFragment.ButtonClickListener) context;
    }

    @Override
    public void onClick(View view)
    {
        //Log.d(tag, "clicked");
        if(listener != null)
        {
            //Log.d(tag, "listener not null");
            listener.addHeroClicked(view);
        }
    }

    interface ButtonClickListener
    {
        void addHeroClicked(View view);
    }

    public void addHero()
    {
        //Log.d(tag, "addHero");
        final Dialog dialog = new Dialog(getActivity());
        dialog.setContentView(R.layout.dialog);
        dialog.setTitle("Add Hero");
        dialog.setCancelable(true);

        final EditText editText = (EditText) dialog.findViewById(R.id.editTextHero);
        Button button = (Button) dialog.findViewById(R.id.addButton);
        button.setOnClickListener(new View.OnClickListener(){
            @Override
            public void onClick(View v)
            {
                String heroName = editText.getText().toString();
                Hero.heroes[universeId].getSuperheroes().add(heroName);
                adapter.notifyDataSetChanged();
                Hero.heroes[universeId].storeHeroes(getActivity(), universeId);
                dialog.dismiss();
            }
        });
        dialog.show();
    }

    @Override
    public void onCreateContextMenu(ContextMenu menu, View view, ContextMenu.ContextMenuInfo menuInfo)
    {
        super.onCreateContextMenu(menu, view, menuInfo);

        AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) menuInfo;
        String heroName = adapter.getItem(info.position);

        menu.setHeaderTitle("Delete " +heroName+"?");
        menu.add(1, 1, 1, "Yes");
        menu.add(2, 2, 2, "No");
    }

    @Override
    public boolean onContextItemSelected(MenuItem item)
    {
        int itemId = item.getItemId();
        if(itemId == 1)
        {
            AdapterView.AdapterContextMenuInfo info = (AdapterView.AdapterContextMenuInfo) item.getMenuInfo();
            Hero.heroes[universeId].getSuperheroes().remove(info.position);
            adapter.notifyDataSetChanged();
            Hero.heroes[universeId].storeHeroes(getActivity(), universeId);
        }
        return  true;
    }

}
