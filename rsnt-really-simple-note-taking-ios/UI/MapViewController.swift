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
//
//struct GlobalVariables {
//   static var coordArray = [CLLocationCoordinate2D]()
//}

import UIKit
import MapKit
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationNme = NSNotification.Name("NotificationIdf")
        
//        print(GlobalVariables.coordArray)
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        
        
//        DispatchQueue.main.async {
//        if GlobalVariables.coordArray.contains(where: { (CLLocationCoordinate2D) -> Bool in
//            true}){
//            for i in GlobalVariables.coordArray {
//                let myLat = 38.0000
//                let myLong = -97.0000
//                let myCoords =  CLLocationCoordinate2DMake(myLat, myLong)
//                let annotation = MKPointAnnotation()
//                annotation.coordinate = myCoords

//                self.mapView.addAnnotation(annotation)
//                mapView.addAnnotations(pizzaAnnotations.restaurants)
//                }
//            }
//        }
    }

    
    @objc func longTap(sender: UIGestureRecognizer){
//        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        }
        

        

    // Core data initialization
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        // create alert
        let alert = UIAlertController(
            title: "Could note get app delegate",
            message: "Could note get app delegate, unexpected error occurred. Try again later.",
            preferredStyle: .alert)

        // add OK action
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default))
        // show alert
        self.present(alert, animated: true)

        return
    }


    // As we know that container is set up in the AppDelegates so we need to refer that container.
    // We need to create a context from this container
    let managedContext = appDelegate.persistentContainer.viewContext

    // set context in the storage
    // this needs to be called before
    ReallySimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)


    }

    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            print(GlobalVariables.coordArray)
//            annotation.title = "Click to go to journal!"

            self.mapView.addAnnotation(annotation)
//        print(annotation.coordinate)
//        GlobalVariables.coordArray.append(annotation.coordinate)
//        print(GlobalVariables.coordArray)
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


