//
//  dependentPickerViewController.swift
//  lab1
//
//  Created by Siddharth on 2/4/17.
//  Copyright © 2017 Siddharth. All rights reserved.
//

import UIKit

class dependentPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryCityPicker: UIPickerView!
    
    var countryCity = [String: [String]]()
    var country = [String]()
    var city = [String]()
    
    var fileExists = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let filePath: String = Bundle.main.path(forResource: "countryCity", ofType: "plist")
        {
            //extracting the data
            countryCity = NSDictionary(contentsOfFile: filePath) as! [String: [String]]
            //getting all countries
            country = Array(countryCity.keys)
            //getting all cities
            city = countryCity[country[0]]! as [String]
            
            //Displaying the first city and country by default
            countryLabel.text = "Country: \(country[0])"
            cityLabel.text = "City: \(city[0])"
            
            fileExists = true
        }
        else
        {
            //alert needs to be displayed only after the view has appeared and been added to the hierarchy
            fileExists = false
        }
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if(fileExists == false)
        {
            let alertController = UIAlertController(title: "Oops", message:
                "File doesn't exist", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(component==0)
        {
            return country.count
        }
        else
        {
            return city.count
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(component==0)
        {
            return country[row]
        }
        else
        {
            return city[row]
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component==0)
        {
            //Getting the country selected, then the cities for that country
            city = countryCity[country[row]]!
            countryCityPicker.reloadComponent(1)
        }
        let selectedCity: String = city[countryCityPicker.selectedRow(inComponent: 1)]
        let selectedCountry: String = country[countryCityPicker.selectedRow(inComponent: 0)]
        
        countryLabel.text = "Country: \(selectedCountry)"
        cityLabel.text = "City: \(selectedCity)"
    }
}
