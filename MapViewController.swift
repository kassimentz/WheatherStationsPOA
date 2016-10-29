//
//  MapViewController.swift
//  WheatherStationsPOA
//
//  Created by iossenac on 29/10/16.
//  Copyright © 2016 Kassiane Mentz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var weatherStation: WeatherStation?
    var annotation: MKPointAnnotation!
    
    func addMapAnnotation() {
        if let weatherStation = weatherStation {
            let latDelta: CLLocationDegrees = 0.09
            let lonDelta: CLLocationDegrees = 0.09
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            
            let location = CLLocationCoordinate2D(latitude: weatherStation.latitude!, longitude: weatherStation.longitude!)
            
            annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            if let temperatura = weatherStation.temperaturaExterna {
                annotation.title = "Temperatura: \(temperatura)"
            } else {
                annotation.title = "Temperatura: -"
            }
            if let sensacao = weatherStation.sensacaoTermica {
                annotation.subtitle = "Sensação Térmica: \(sensacao)"
            } else {
                annotation.subtitle = "Sensação: -"
            }
            
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationview = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            
            pinAnnotationview.pinTintColor = .purple
            pinAnnotationview.isDraggable = true
            pinAnnotationview.canShowCallout = true
            pinAnnotationview.animatesDrop = true
            pinAnnotationview.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIButton
            
            return pinAnnotationview
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            performSegue(withIdentifier: "moreDetail", sender: weatherStation)
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        self.mapView.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = weatherStation?.station
        
        self.mapView.delegate = self

        addMapAnnotation()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "moreDetail" {
            let detailStationViewController = segue.destination as! DetailStationViewController
            if let weatherStation = sender as? WeatherStation {
                detailStationViewController.weatherStation = weatherStation
            }
        }
    }
    

}
