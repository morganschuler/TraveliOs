//
//  MapViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Morgan Schuler on 1/15/20.
//
//
//import UIKit
//import MapKit
//
//class MapViewController: UIViewController {
//    @IBOutlet weak var mapView: MKMapView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

struct GlobalVariables {
   static var coordArray = [CLLocationCoordinate2D]()
}

import UIKit
import MapKit
class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(GlobalVariables.coordArray)
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
    }

    @objc func longTap(sender: UIGestureRecognizer){
//        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
        
        DispatchQueue.main.async {
        if GlobalVariables.coordArray.contains(where: { (CLLocationCoordinate2D) -> Bool in
            true}){
            for i in GlobalVariables.coordArray {
                let myLat = i.latitude
                let myLong = i.longitude
                let myCoords =  CLLocationCoordinate2DMake(myLat, myLong)
                let annotation = MKPointAnnotation()
                annotation.coordinate = myCoords
                
                self.mapView.addAnnotation(annotation)
                }
            }
        }
        

        
    }

    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
//            annotation.title = "Click to go to journal!"

            self.mapView.addAnnotation(annotation)
        print(annotation.coordinate)
        GlobalVariables.coordArray.append(annotation.coordinate)
        print(GlobalVariables.coordArray)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segue1" {
                let ReallySimpleNoteCreateChangeViewController = segue.destination as! ReallySimpleNoteCreateChangeViewController
                // TODO: something
                
            }
        }
    
}


extension MapViewController: MKMapViewDelegate{

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }

        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
//            pinView!.rightCalloutAccessoryView = UIButton(type: .contactAdd)
//            pinView!.rightCalloutAccessoryView = UITextFieldDelegate
            pinView!.pinTintColor = UIColor.red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if ((view.annotation?.title!) != nil) {
               print("do something")
            }
        }
    }
    
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
           performSegue(withIdentifier: "segue1", sender: nil)
       }
   }


