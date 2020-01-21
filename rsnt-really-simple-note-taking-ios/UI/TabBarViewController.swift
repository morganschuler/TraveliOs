//
//  TabBarViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Morgan Schuler on 1/20/20.
//  Copyright © 2020 Németh László Harri. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("tabBar")
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

        let managedContext = appDelegate.persistentContainer.viewContext
        ReallySimpleNoteStorage.storage.setManagedContext(managedObjectContext: managedContext)
        }
    }



