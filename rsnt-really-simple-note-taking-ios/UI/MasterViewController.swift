//
//  MasterViewController.swift
//  rsnt-really-simple-note-taking-ios
//

//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil

    override func viewDidLoad() {
        print("master view loaded")
        super.viewDidLoad()
//        let notificationNme = NSNotification.Name("NotificationIdf")
//           NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.reloadTableview), name: notificationNme, object: nil)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
//        // Core data initialization
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            // create alert
//            let alert = UIAlertController(
//                title: "Could note get app delegate",
//                message: "Could note get app delegate, unexpected error occurred. Try again later.",
//                preferredStyle: .alert)
//            
//            // add OK action
//            alert.addAction(UIAlertAction(title: "OK",
//                                          style: .default))
//            // show alert
//            self.present(alert, animated: true)
//
//            return
//        }
//        
//        
//        // As we know that container is set up in the AppDelegates so we need to refer that container.
//        // We need to create a context from this container
//        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set context in the storage
        // this needs to be called before
//        ReallySimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        navigationItem.rightBarButtonItem = addButton
//        if let split = splitViewController {
//            let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
//        }
    }
    
    @objc func reloadTableview() {
        self.tableView.reloadData()
    }
    
     @objc func refresh() {
        self.tableView.reloadData() // a refresh the tableView.
    }

//    @IBAction func unwindSegueToVC1(segue:UIStoryboardSegue) { }

    override func viewWillAppear(_ animated: Bool) {
//        if splitViewController != nil {
//            clearsSelectionOnViewWillAppear = splitViewController?.isCollapsed ?? true
//            super.viewWillAppear(animated)  }
        super.viewWillAppear(animated)
        tableView.reloadData()
        

    }

    @objc
    func insertNewObject(_ sender: Any) {
        performSegue(withIdentifier: "showCreateNoteSegue", sender: self)
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                //let object = objects[indexPath.row]
                let object = ReallySimpleNoteStorage.storage.readNote(at: indexPath.row)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReallySimpleNoteStorage.storage.count()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReallySimpleNoteUITableViewCell

        if let object = ReallySimpleNoteStorage.storage.readNote(at: indexPath.row) {
        cell.noteTitleLabel!.text = object.noteTitle
        cell.noteTextLabel!.text = object.noteText
            cell.noteDateLabel!.text = ReallySimpleNoteDateHelper.convertDate(date: Date.init(seconds: object.noteTimeStamp))
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            ReallySimpleNoteStorage.storage.removeNote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

