//
//  CountryDetailViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Morgan Schuler on 1/15/20.

//

import UIKit
import WebKit


class CountryDetailViewController: UIViewController {
    var name = ""
    var capital = ""
    var subregion = ""
    var demonym = ""
    var flag = ""
    
    public var svgFlag: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.reloadsvgFlag()
            }
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    //    @IBOutlet weak var backButton: UINavigationItem!
    @IBOutlet weak var subregionLabel: UILabel!
    //
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var demonymLabel: UILabel!
    
    @IBOutlet weak var imageWebView: WKWebView!
    //    @IBAction func favoriteButton(_ sender: Any) {
//         let myVC = storyboard?.instantiateViewController(withIdentifier: "FavoriteTableViewController") as! FavoriteTableViewController
//                myVC.favoriteCell = UITableViewCell()
//                myVC.my = name
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
//        self.imageWebView.loadHTMLString("No flag available", baseURL: nil)

    }
    
    func reloadsvgFlag() {
        self.imageWebView.loadHTMLString("<div style='width:100%;height:100%;background-color:red;'>\(self.svgFlag)</div>", baseURL: nil)
    }



}
