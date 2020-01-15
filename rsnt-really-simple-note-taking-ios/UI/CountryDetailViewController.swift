//
//  CountryDetailViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Morgan Schuler on 1/15/20.
//  Copyright © 2020 Németh László Harri. All rights reserved.
//

import UIKit


class CountryDetailViewController: UIViewController {
    var name = ""
    var capital = ""
    var subregion = ""
    var demonym = ""
    var flag = ""
    
    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet weak var backButton: UINavigationItem!
    @IBOutlet weak var subregionLabel: UILabel!
    //
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var demonymLabel: UILabel!
    
    //    @IBAction func favoriteButton(_ sender: Any) {
//         let myVC = storyboard?.instantiateViewController(withIdentifier: "FavoriteTableViewController") as! FavoriteTableViewController
//                myVC.favoriteCell = UITableViewCell()
//                myVC.myString = name
//        //        self.tabBarController?.selectedIndex = 2;
//                navigationController?.pushViewController(myVC, animated: true)
//    }

    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        var secondController = segue.destination as! FavoritesTableViewController
//        secondController.myString =
//    }
  
//    @IBAction func favoriteButton(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "FavoritesViewController") as! FavoritesViewController
//        
//        vc.favoriteLabel = UILabel()
//        vc.favoriteArray = name
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = name
        capitalLabel.text = "Capital:  \(capital)"
        subregionLabel.text = "Subregion: \(subregion)"
        demonymLabel.text = "Demonyn: \(demonym)"
        
     

    }
    



}
