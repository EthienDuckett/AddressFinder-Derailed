//
//  ViewController.swift
//  AddressFinder
//
//  Created by 21SP-2 on 4/19/22.
//

import UIKit
import MapKit

class ButtonMod: UIButton {
    var indice:Int = 0
}


class ViewController: UIViewController {
    var mapAPI = MapAPI()
    var location_index = 0
    
    @IBOutlet var locationsView: UIStackView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var map: MKMapView!
    var location_buttons:[ButtonMod] = []
    
    @IBOutlet var searchField: UITextField!
    
    fileprivate func moveMapToLocation() {
        if mapAPI.locations.count > location_index {
            print("setting location to \(mapAPI.locations[location_index].name)")
            map.setCenter(mapAPI.locations[location_index].coordinate, animated:true)
            map.setRegion(mapAPI.region, animated:true)
        } else {
            print("Location not found")
        }
    }
    
    @IBAction func queryWithSearchField(_ sender: Any) {
        for button in location_buttons {
            button.removeFromSuperview()
        }
        location_buttons.removeAll()
        mapAPI.locations.removeAll()
        if textField.text!.isEmpty {
            return
        }
        mapAPI.getLocation(address: textField.text!, delta: 0.5)
        print(mapAPI.locations)
        moveMapToLocation()
        for i in 0..<mapAPI.locations.count {
            print("iteration")
            location_buttons.append(ButtonMod(type: ButtonMod.ButtonType.system))
            location_buttons[i].frame = CGRect(x:0, y:20*i, width:150, height:20)
//            button.backgroundColor = UIColor.blue
            location_buttons[i].setTitle(mapAPI.locations[i].name, for: .normal)
            location_buttons[i].setTitleColor(UIColor.systemBlue, for: .normal)
            
            location_buttons[i].indice = i
            location_buttons[i].addTarget(self,
                                          action: #selector(changeButtonLocation),
                                          for:.touchUpInside)
            locationsView.addSubview(location_buttons[i])
        }
    }
    @IBAction func changeButtonLocation(sender:ButtonMod) {
        print("set location_index to \(sender.indice)")
        location_index = sender.indice
        moveMapToLocation()
    }
    
    
    
    @IBOutlet var Body: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }


}

