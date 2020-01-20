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
import CoreLocation



class MapViewController: UIViewController {
    
//    var coordinates: [MKPointAnnotation] = []
    var routeArr: [CLLocationCoordinate2D] = []
    
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    @IBOutlet weak var cornerMap: MKMapView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let notificationNme = NSNotification.Name("NotificationIdf")
//        print(GlobalVariables.coordArray)
        mapView.delegate = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapView.addGestureRecognizer(longTapGesture)
        

        self.cornerMap.layer.borderColor = UIColor.black.cgColor
        self.cornerMap.layer.borderWidth = 2.0;
        self.cornerMap.isZoomEnabled = false;
        self.cornerMap.isScrollEnabled = false;
        self.cornerMap.isUserInteractionEnabled = false;
      
        setUpMapView()


//        func setupMap() {
//            mapView.delegate = self
//            // BusStop implements the MKAnnotation protocol, I have an array of them
////            let routeCoordinates = coordinates.map({ $0.coordinate })
////            let routeLine = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
////            mapView.setVisibleMapRect(routeLine.boundingMapRect, animated: false)
////            mapView.addOverlay(routeLine)
//        }

        
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
    
    func setUpMapView() {
       cornerMap.showsUserLocation = true
       cornerMap.showsCompass = true
       cornerMap.showsScale = true
       currentLocation()
    }

    func currentLocation() {
       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       if #available(iOS 11.0, *) {
          locationManager.showsBackgroundLocationIndicator = true
       } else {
          // Fallback on earlier versions
       }
       locationManager.startUpdatingLocation()
    }


    func applicationDidBecomeActive(application: UIApplication) {
         //This method is called when the rootViewController is set and the view.
        let alert = UIAlertController(title: "some title", message: "some message", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    
    @objc func longTap(sender: UIGestureRecognizer){
//        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
//            coordinates.append(locationOnMap)
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
//            print(GlobalVariables.coordArray)
//            annotation.title = "Click to go to journal!"
            self.mapView.addAnnotation(annotation)
//        for index in 0..<GlobalVariables.locationsList.count{
//        var lat = Double(GlobalVariables.locationsList[index].latitude)
//        var long = Double(GlobalVariables.locationsList[index].longitude)
//        var coordinatesToAppend = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        coordinates.append(annotation)
//        print(coordinates)


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

//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            if ((view.annotation?.title!) != nil) {
//               print("do something")
//            }
//        }
//    }
    
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
           performSegue(withIdentifier: "segue1", sender: nil)
       }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        if let polyline = overlay as? MKPolyline {
//            let polylineRenderer = MKPolylineRenderer(overlay: polyline)
//            polylineRenderer.strokeColor = .blue
//            polylineRenderer.lineWidth = 3
//            return polylineRenderer
//        }
//        return MKOverlayRenderer(overlay: overlay)
//    }
    
    
}

extension MapViewController: CLLocationManagerDelegate {
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
      let location = locations.last! as CLLocation
      let currentLocation = location.coordinate
      let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 10000, longitudinalMeters: 10000)
      cornerMap.setRegion(coordinateRegion, animated: true)
      locationManager.stopUpdatingLocation()
   }
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      print(error.localizedDescription)
   }
}
