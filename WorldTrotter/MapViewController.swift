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
    let cyclePinLocationsButton = UIButton()
    var pinLocationsArray: [MKPointAnnotation] = []
    var pinLocation = 0
    
    override func loadView() {
        // Create a map view
        mapView = MKMapView()
        mapView.delegate = self
        
        // Set it as *the* view of this view controller
        view = mapView
        
        // create and add birth location pin
        let birthLocationAnnotation = MKPointAnnotation()
        birthLocationAnnotation.title = "Place of birth"
        birthLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
        birthLocationAnnotation.subtitle = "Los Angeles, CA"
        pinLocationsArray.append(birthLocationAnnotation)
        
        // create and add current location pin
        let currentLocationAnnotation = MKPointAnnotation()
        currentLocationAnnotation.title = "Current residence"
        currentLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.8044, longitude: -122.2711)
        currentLocationAnnotation.subtitle = "Oakland, CA"
        pinLocationsArray.append(currentLocationAnnotation)
    
        // create and add interesting location pin
        let interestingLocationAnnotation = MKPointAnnotation()
        interestingLocationAnnotation.title = "Interesting location visited"
        interestingLocationAnnotation.coordinate = CLLocationCoordinate2D(latitude: 42.8047, longitude: 140.6875)
        interestingLocationAnnotation.subtitle = "Niseko, Hokkaido, Japan"
        pinLocationsArray.append(interestingLocationAnnotation)
        
        // add annotations to map view
        mapView.addAnnotations(pinLocationsArray)
    
        // add segmented map control widget
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
        
        // create and add my location button
        myLocationButton.backgroundColor = .blue
        myLocationButton.setTitle("My Location", for: .normal)
        myLocationButton.sizeToFit()
        myLocationButton.translatesAutoresizingMaskIntoConstraints = false
    
        self.view.addSubview(myLocationButton)
        
        let myLocationButtonTopConstraint = myLocationButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8)
        let myLocationButtonLeadingConstraint = myLocationButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let myLocationButtonTrailingConstraint = myLocationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        myLocationButtonTopConstraint.isActive = true
        myLocationButtonLeadingConstraint.isActive = true
        myLocationButtonTrailingConstraint.isActive = true
        
        // create and add cycle pin locations button
        cyclePinLocationsButton.backgroundColor = .red
        cyclePinLocationsButton.setTitle("Cycle Pin Locations", for: .normal)
        cyclePinLocationsButton.sizeToFit()
        cyclePinLocationsButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(cyclePinLocationsButton)
        
        let cyclePinLocationsButtonTopConstraint = cyclePinLocationsButton.topAnchor.constraint(equalTo: myLocationButton.bottomAnchor, constant: 8)
        let cyclePinLocationsButtonLeadingConstraint = cyclePinLocationsButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let cyclePinLocationsButtonTrailingConstraint = cyclePinLocationsButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        cyclePinLocationsButtonTopConstraint.isActive = true
        cyclePinLocationsButtonLeadingConstraint.isActive = true
        cyclePinLocationsButtonTrailingConstraint.isActive = true
        
        cyclePinLocationsButton.addTarget(self, action: #selector(onCyclePinLocations(_:)), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
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
    
    @objc func onCyclePinLocations(_ button: UIButton) {
        // Zoom to pin location
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(pinLocationsArray[pinLocation].coordinate, 10000, 10000), animated: true)
        print("zoom to pin location = \(pinLocationsArray[pinLocation])")
        pinLocation += 1
        if pinLocation >= pinLocationsArray.count {
            pinLocation = 0
        }
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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinTintColor = .red
        } else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
}
