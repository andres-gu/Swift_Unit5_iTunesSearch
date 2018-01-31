//
//  StoreItemListTableViewController.swift
//  iTunesSearch
//
//  Created by Andres Gutierrez on 1/30/18.
//  Copyright © 2018 Andres Gutierrez. All rights reserved.
//

import UIKit

class StoreItemListTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    
    
    
    // add item controller property
    var storeItemsController = StoreItemsController()
    
    var items = [StoreItem]()
    
    let queryOptions = ["movie", "music", "software", "ebook"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func fetchMatchingItems() {
        self.items = []
        let searchTerm = searchBar.text ?? ""
        let mediaType = queryOptions[filterSegmentControl.selectedSegmentIndex]
        
        if !searchTerm.isEmpty {
            
            // set up query dictionary
            let query: [String: String] = [
                "term": searchTerm,
                "country": "US",
                "media": mediaType,
                "limit": "10",
                "lang": "en_us"
            ]
            // use item controller to fetch items
            // if successful, use the main queue to set self.items and reload the table view
            // otherwise print error to console
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            storeItemsController.fetchItems(matching: query, completion: {(fetchedInfo) in
                guard let infoFromFetch = fetchedInfo else { return }
                for info in infoFromFetch {
                    self.items.append(info)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            })
            
        }
        
    }
    
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        // set label to the item's name
        // set detail label to the item's subtitle
        // reset the image view to the gray image
        cell.textLabel?.text = item.trackName
        cell.detailTextLabel?.text = item.artist
        cell.imageView?.image = #imageLiteral(resourceName: "Solid_gray")
        
        // initialize a network task to fetch the item's artwork
        // if successful, use the main queue to capture the cell, to initialize a UIImage and set the cell's image view's to the
        // resume the task
        
        let task = URLSession.shared.dataTask(with: item.artwork, completionHandler: { (data, response, error) in
            if let data = data, let image = UIImage(data: data) { DispatchQueue.main.async {
//                cell.textLabel?.text = item.trackName
//                cell.detailTextLabel?.text = item.artist
                cell.imageView?.image = image
                }
            }
        })
        task.resume()
    }
    
    @IBAction func filterOptionUpdated(_ sender: UISegmentedControl) {
        //fetchMatchingItems()
        print("\\\\\\\\> Search type: ", queryOptions[filterSegmentControl.selectedSegmentIndex])
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StoreItemListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        fetchMatchingItems()
        searchBar.resignFirstResponder()
    }
}
