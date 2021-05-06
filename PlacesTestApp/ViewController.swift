//
//  ViewController.swift
//  PlacesTestApp
//
//  Created by steve benedick on 4/30/21.
//

import UIKit
import AEPPlaces
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getNearbyPois(_ sender: Any) {
        let location = CLLocation(latitude: 40.4350229, longitude: -111.8918356)
        Places.getNearbyPointsOfInterest(forLocation: location, withLimit: 10) { pois in
            print("pois: \(pois)")
        }
    }
    
    @IBAction func getLastKnownLocation(_ sender: Any) {
        Places.getLastKnownLocation() { location in
            if let location = location {
                print("location returned from closure: (\(location.coordinate.latitude), \(location.coordinate.longitude))")
            }
        }
    }
}

