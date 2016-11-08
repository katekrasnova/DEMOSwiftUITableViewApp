//
//  MapViewController.swift
//  Eateries
//
//  Created by Ivan Akulov on 02/10/2016.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

  var restaurant: Restaurant!
  
  @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
      mapView.delegate = self
      
      let geocoder = CLGeocoder()
      geocoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
        
        guard error == nil else { return }
        guard let placemarks = placemarks else { return }
        
        let placemark = placemarks.first!
        
        let annotation = MKPointAnnotation()
        annotation.title = self.restaurant.name
        annotation.subtitle = self.restaurant.type
        
        guard let location = placemark.location else { return }
        annotation.coordinate = location.coordinate
        
        self.mapView.showAnnotations([annotation], animated: true)
        self.mapView.selectAnnotation(annotation, animated: true)
        
      }

        // Do any additional setup after loading the view.
    }

  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard !(annotation is MKUserLocation) else { return nil }
    
    let annotaionIdentifier = "restAnnotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotaionIdentifier) as? MKPinAnnotationView
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotaionIdentifier)
      annotationView?.canShowCallout = true
    }
    
    let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    rightImage.image = UIImage(data: restaurant.image as! Data)
    annotationView?.rightCalloutAccessoryView = rightImage
    
    annotationView?.pinTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    
    return annotationView
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
