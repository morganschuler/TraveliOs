
import UIKit
import MapKit

class ReallySimpleNoteCreateChangeViewController : UIViewController, UITextViewDelegate {
    
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
        
        self.dismiss(animated: true, completion: nil)

//        performSegue(
//            withIdentifier: "backToMapView",
//            sender: self)
}
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if noteTextTextView.textColor == UIColor.lightGray {
            noteTextTextView.text = nil
            noteTextTextView.textColor = UIColor.black
        }
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
//            performSegue(
//                withIdentifier: "backToMapView",
//                sender: self)
//            self.dismiss(animated: true, completion: nil)
//        } else {
            // create alert
            let alert = UIAlertController(
                title: "Note saved!",
                message: nil,
                preferredStyle: .alert)
            
            // add OK action
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default )
//            { (_) in self.performSegue(
//                                              withIdentifier: "backToMapView",
//                                              sender: self)}
            )
            // show alert
            
            self.present(alert, animated: true)

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set text view delegate so that we can react on text change
        noteTextTextView.delegate = self
        self.noteTextTextView.addDoneButton(title: "Done", target: self, selector: #selector(tapDone(sender:)))
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
        backButton.action = #selector(self.backButtonClicked)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // check if empty string or nil
        if noteTextTextView == nil {
            noteTextTextView.text = "Reflect on your travels! \nWhat did you see? \nWhat food did you try? \nWhat was your favorite part? Jot it down!"
            noteTextTextView.textColor = UIColor.lightGray
        } else {
            noteTextTextView.textColor = UIColor.black
        }
    }
    
     @objc func tapDone(sender: Any) {
         self.view.endEditing(true)
     }
    
    @objc func backButtonClicked() {
        print("button clicked")
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
