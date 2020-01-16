//
//  ReallySimpleNoteCreateChangeViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Németh László Harri on 2019. 01. 22..
//  Copyright © 2019. Németh László Harri. All rights reserved.
//

import UIKit
import MapKit

class ReallySimpleNoteCreateChangeViewController : UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDoneButton: UIButton!
    @IBOutlet weak var noteDateLabel: UILabel!
    
    private let noteCreationTimeStamp : Int64 = Date().toSeconds()
    private(set) var changingReallySimpleNote : ReallySimpleNote?

    @IBAction func noteTitleChanged(_ sender: UITextField, forEvent event: UIEvent) {
        if self.changingReallySimpleNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( sender.text?.isEmpty ?? true ) || ( noteTextTextView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton, forEvent event: UIEvent) {
        // distinguish change mode and create mode
        if self.changingReallySimpleNote != nil {
            // change mode - change the item
            changeItem()
        } else {
            // create mode - create the item
            addItem()
        }
    }
    
    func setChangingReallySimpleNote(changingReallySimpleNote : ReallySimpleNote) {
        self.changingReallySimpleNote = changingReallySimpleNote
    }
    
    private func addItem() -> Void {
        let note = ReallySimpleNote(
            noteTitle:     noteTitleTextField.text!,
            noteText:      noteTextTextView.text,
            noteTimeStamp: noteCreationTimeStamp)

        
        ReallySimpleNoteStorage.storage.addNote(noteToBeAdded: note)
        
        performSegue(
            withIdentifier: "backToMasterView",
            sender: self)
    }

    private func changeItem() -> Void {
        // get changed note instance
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // change the note through note storage
            ReallySimpleNoteStorage.storage.changeNote(
                noteToBeChanged: ReallySimpleNote(
                    noteId:        changingReallySimpleNote.noteId,
                    noteTitle:     noteTitleTextField.text!,
                    noteText:      noteTextTextView.text,
                    noteTimeStamp: noteCreationTimeStamp))
            // navigate back to list of notes
            performSegue(
                withIdentifier: "backToMasterView",
                sender: self)
        } else {
            // create alert
            let alert = UIAlertController(
                title: "Unexpected error",
                message: "Cannot change the note, unexpected error occurred. Try again later.",
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default ) { (_) in self.performSegue(
                                              withIdentifier: "backToMasterView",
                                              sender: self)})
            // show alert
            self.present(alert, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
               let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
               mapView.addGestureRecognizer(longTapGesture)
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        
        // check if we are in create mode or in change mode
        if let changingReallySimpleNote = self.changingReallySimpleNote {
            // in change mode: initialize for fields with data coming from note to be changed
            noteDateLabel.text = ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
            noteTextTextView.text = changingReallySimpleNote.noteText
            noteTitleTextField.text = changingReallySimpleNote.noteTitle
//            mapView.annotations = (changingReallySimpleNote.noteMap)
            // enable done button by default
            noteDoneButton.isEnabled = true
        } else {
            // in create mode: set initial time stamp label
            noteDateLabel.text = ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: noteCreationTimeStamp))
        }
        
        // initialize text view UI - border width, radius and color
        noteTextTextView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        noteTextTextView.layer.borderWidth = 1.0
        noteTextTextView.layer.cornerRadius = 5

        // For back button in navigation bar, change text
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
   
    }
    
    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
            self.mapView.addAnnotation(annotation)
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
           print("long tap")
           if sender.state == .began {
               let locationInView = sender.location(in: mapView)
               let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
               /// this is the location to .addAnnotation
               addAnnotation(location: locationOnMap)
           }
        
       }

    //Handle the text changes here
    func textViewDidChange(_ textView: UITextView) {
        if self.changingReallySimpleNote != nil {
            // change mode
            noteDoneButton.isEnabled = true
        } else {
            // create mode
            if ( noteTitleTextField.text?.isEmpty ?? true ) || ( textView.text?.isEmpty ?? true ) {
                noteDoneButton.isEnabled = false
            } else {
                noteDoneButton.isEnabled = true
            }
        }
    }


    
    }


extension ReallySimpleNoteCreateChangeViewController : MKMapViewDelegate{

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


