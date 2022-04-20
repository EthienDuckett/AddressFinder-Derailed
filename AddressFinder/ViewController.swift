//
//  ViewController.swift
//  AddressFinder
//
//  Created by 21SP-2 on 4/19/22.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    var mapAPI = MapAPI()
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var searchField: UITextField!
    @IBAction func queryWithSearchField(_ sender: Any) {
        mapAPI.getLocation(address: textField.text!, delta: 0.5)
        print(mapAPI.locations)
        map.setCenter(mapAPI.locations[0].coordinate, animated:false)
        map.setRegion(mapAPI.region, animated:false)
    }
    
    @IBOutlet var Body: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }


}

