//
//  TripsTableViewController.swift
//  rsnt-really-simple-note-taking-ios
//
//  Created by Morgan Schuler on 1/15/20.
//  Copyright © 2020 Németh László Harri. All rights reserved.
//

import UIKit

struct Country: Decodable {
    let name: String
    let capital: String
    let subregion: String
    let demonym: String
}
 

class TripsViewController: UITableViewController {
    var favoriteArray = [] as [String]
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    var filteredCountries: [Country] = []

    var availableCountries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let url = "https://restcountries.eu/rest/v2/all"
        let urlObj = URL(string: url)
        
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            do {
                self.availableCountries = try JSONDecoder().decode([Country].self, from:data!)
//                print(countries)
//                for country in self.availableCountries {
//                    print(self.availableCountries)
//                }
            } catch {
                print("We got an error")
            }
        }.resume()
   
        tableView.register((UITableViewCell.self), forCellReuseIdentifier: "cellIdentifier")
        
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Countries"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true

        
 
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }  // Optional
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          if isFiltering {
          return filteredCountries.count
        }
          
        return availableCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for:indexPath)
        let country: Country
        if isFiltering {
            country = filteredCountries[indexPath.row]
          } else {
            country = availableCountries[indexPath.row]
          }
            cell.textLabel?.text = country.name
          return cell
        }
        
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       var availableCountry = self.availableCountries[indexPath.row]

        if isFiltering {
             availableCountry = self.filteredCountries[indexPath.row]
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CountryDetailViewController") as! CountryDetailViewController
        
        vc.nameLabel = UILabel()
        vc.name = availableCountry.name
        
        vc.capitalLabel = UILabel()
        vc.capital = availableCountry.capital
        
        vc.subregionLabel = UILabel()
        vc.subregion = availableCountry.subregion
        
        vc.demonymLabel = UILabel()
        vc.demonym = availableCountry.demonym
        
//        vc.flagImage = UIImageView()
//        vc.flagImage = availableCountry.flag
        
        self.navigationController!.pushViewController(vc, animated: true)
        
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        filteredCountries = availableCountries.filter { (country : Country ) -> Bool in
        return country.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView,
                      trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
       {
           // Write action code for the trash
           let FavoriteAction = UIContextualAction(style: .normal, title:  "Favorite", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
//               print("Update action ...")
               success(true)

            let cellName = self.availableCountries[indexPath.row].name

            let storyboard = UIStoryboard(name: "Main", bundle: nil);
//            ftvc.countryLabel = UILabel()
//            ftvc.country = cellName
                if !self.favoriteArray.contains(cellName) {
               self.favoriteArray.append(cellName)
                }
            print(self.favoriteArray)




//            let alertVC = UIAlertController(title: "Favorite Added!", preferredStyle: .alert)
//            let otherVc = FavoritesViewController()
//            if  !otherVc.favoriteArray2.contains(cellName) {
//                otherVc.favoriteArray2.append(cellName)
//            }
//            otherVc.favoriteArray2
//            print("other array:", otherVc.favoriteArray2)
//            var defaults = UserDefaults.standardUserDefaults()
//            defaults.setObject(favoriteArray, forKey: "YourKey")
            let alert = UIAlertController(title: "Country added to travel list!", message: "Go check out your favorited countries under the heart tab.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK!", style: .default, handler: nil))

            self.present(alert, animated: true)

           })
           FavoriteAction.backgroundColor = .green
//            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let newViewController = storyBoard.instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
//            self.navigationController?.pushViewController(newViewController, animated: true)



           return UISwipeActionsConfiguration(actions: [FavoriteAction])
       }
    

        
}
    

extension TripsViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
        

