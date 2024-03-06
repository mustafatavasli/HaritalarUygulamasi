//
//  ViewController.swift
//  HaritalarUygulamasi
//
//  Created by Mustafa TAVASLI on 4.03.2024.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var isimTextField: UITextField!
    @IBOutlet weak var notTextField: UITextField!
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Kullanıcının haritada bir yere uzun süre basması işlemi
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec(gestureRecognizer:)))
        
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    // .location için gestureRecognizer tekrar kullandık.
    @objc func konumSec(gestureRecognizer : UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let dokunulanNokta = gestureRecognizer.location(in: mapView)
            let dokunulanNoktaKoordinat = mapView.convert(dokunulanNokta, toCoordinateFrom: mapView)
            
            // Haritadaki yeri işaretleme
            let annotation = MKPointAnnotation()
            annotation.coordinate = dokunulanNoktaKoordinat
            annotation.title = isimTextField.text
            annotation.subtitle = notTextField.text
            
            // Yer İşaretini Ekleme
            mapView.addAnnotation(annotation)
        }
    }
    
    // Kullanıcının konumunu alma işlemi
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        // Zoom seviyesine göre harita boyutu ayarlanması
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}

