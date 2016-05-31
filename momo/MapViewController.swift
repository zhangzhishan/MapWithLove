//
//  MapViewController.swift
//  momo
//
//  Created by Zhishan Zhang on 3/23/16.
//  Copyright © 2016 Zhishan Zhang. All rights reserved.
//

import UIKit
import MapKit
import AVFoundation



class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var player = AVAudioPlayer()

    
    override func loadView() {
        mapView = MKMapView()
        
        mapView.showsUserLocation = true
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Statellite"])
        
        segmentedControl.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        segmentedControl.addTarget(self, action: "mapTypeChanged:", forControlEvents: .ValueChanged)
        
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: 8)
        
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraintEqualToAnchor(margins.trailingAnchor)
        
        topConstraint.active = true
        leadingConstraint.active = true
        trailingConstraint.active = true
        
        let locationButton = UIButton(type: UIButtonType.System) as UIButton
        locationButton.frame = CGRectMake(100, 100, 100, 50)
        locationButton.backgroundColor = UIColor.greenColor()
        locationButton.setTitle("my location", forState: UIControlState.Normal)
        locationButton.addTarget(self, action: "showPlace:", forControlEvents: UIControlEvents.TouchUpInside)
        
        view.addSubview(locationButton)
        
        let pinButton = UIButton(type: UIButtonType.System) as UIButton
        pinButton.frame = CGRectMake(300, 500, 100, 100)
//        pinButton.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.7)
        pinButton.setTitle("pin", forState: UIControlState.Normal)
        pinButton.addTarget(self, action: "putPin:", forControlEvents: UIControlEvents.TouchUpInside)
        pinButton.setImage(UIImage(named: "clock.png"), forState: UIControlState.Normal)
        view.addSubview(pinButton)
    }
    
    func putPin(sender: UIButton) {
        let objectAnnotation = MKPointAnnotation()
        
        objectAnnotation.coordinate = locationManager.location!.coordinate
        
        objectAnnotation.title = "pekg"
        objectAnnotation.subtitle = "heiheihei"
        mapView.addAnnotation(objectAnnotation)
    }
    
    func showPlace(sender: UIButton!) {
        let latDelata = 0.5
        let longDelata = 0.5
        let currentLocationSpan = MKCoordinateSpanMake(latDelata, longDelata)

//        let center = CLLocation(latitude: 32.029171, longitude: 118.788231).coordinate

        let center = locationManager.location!.coordinate
        print("\(center.latitude)")
        let currentRegion = MKCoordinateRegion(center: center, span: currentLocationSpan)
        mapView.setRegion(currentRegion, animated: true)
        
        
        let url:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bgmusic", ofType: "mp3")!)
        
        do { self.player = try AVAudioPlayer(contentsOfURL: url, fileTypeHint: nil) }
        catch let error as NSError {
            print(error.description)
        }
        
        self.player.numberOfLoops = 1000
        self.player.prepareToPlay()
        self.player.play()
        
        
    }
    
    func mapTypeChanged(segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .Standard
        case 1:
            mapView.mapType = .Hybrid
        case 2:
            mapView.mapType = .Satellite
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.mapView.delegate = self
        
    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        var locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation)
        -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let reuserId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuserId)
                as? MKPinAnnotationView
            if pinView == nil {
                //创建一个大头针视图
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuserId)
                pinView?.canShowCallout = true
                pinView?.animatesDrop = true
                //设置大头针颜色
                pinView?.pinTintColor = UIColor.greenColor()
                //设置大头针点击注释视图的右侧按钮样式
                pinView?.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }else{
                pinView?.annotation = annotation
            }
            
            return pinView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {
            print("点击注释视图按钮")
    }
}