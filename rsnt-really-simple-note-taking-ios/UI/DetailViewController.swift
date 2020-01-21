//
//  DetailViewController.swift

//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var noteTitleLabel: UILabel!
    @IBOutlet weak var noteTextTextView: UITextView!
    @IBOutlet weak var noteDate: UILabel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let topicLabel = noteTitleLabel,
               let dateLabel = noteDate,
               let textView = noteTextTextView {
                topicLabel.text = detail.noteTitle
                dateLabel.text = ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: detail.noteTimeStamp))
                textView.text = detail.noteText
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        print("detail view load")
      
            // Update the view.
//        self.loadView()
        
    }
    
   @IBAction func goBackToOneButtonTapped(_ sender: Any) {
           performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
      }

    var detailItem: ReallySimpleNote? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("back")
        if segue.identifier == "showChangeNoteSegue" {
            let changeNoteViewController = segue.destination as! ReallySimpleNoteCreateChangeViewController
            if let detail = detailItem {
                changeNoteViewController.setChangingReallySimpleNote(
                    changingReallySimpleNote: detail)
            }
        }
    }
}

