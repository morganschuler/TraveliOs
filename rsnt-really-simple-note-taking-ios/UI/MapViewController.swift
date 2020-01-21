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
    }

        
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
//    }
    
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
        }
    }


    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            self.mapView.addAnnotation(annotation)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "segue1" {
                let ReallySimpleNoteCreateChangeViewController = segue.destination as! ReallySimpleNoteCreateChangeViewController

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
    
   func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
           performSegue(withIdentifier: "segue1", sender: nil)
       }
    
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
