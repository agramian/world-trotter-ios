//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Abtin Gramian on 4/9/18.
//  Copyright © 2018 Abtin Gramian. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    let myLocationButton = UIButton()
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        
        // Set it as *the* view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(mapTypeChanged(_:)), for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        
        myLocationButton.backgroundColor = .blue
        myLocationButton.setTitle("My Location", for: .normal)
        myLocationButton.sizeToFit()
        myLocationButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(myLocationButton)
        
        let buttonTopConstraint = myLocationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let buttonLeadingConstraint = myLocationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let buttonTrailingConstraint = myLocationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        buttonTopConstraint.isActive = true
        buttonLeadingConstraint.isActive = true
        buttonTrailingConstraint.isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            //locationManager.startUpdatingLocation()
            myLocationButton.addTarget(self, action: #selector(onMyLocation(_:)), for: .touchUpInside)
        }
    
        print("MapViewController loaded its view.")
    }

    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }

    @objc func onMyLocation(_ button: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //Zoom to user location
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(locValue, 200, 200), animated: true)
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error = \(error)")
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        print("MapViewController will start locating user.")
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("MapViewController did stop locating user.")
    }

}
