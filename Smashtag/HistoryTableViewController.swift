//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by lalitote on 08.12.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        title = "Recent Searches"
    }
    private struct Storyboard {
        static let CellReuseIdentifier = "History Cell"
        static let HistorySegueIdentifier = "History Segue"
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearches().values.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = RecentSearches().values[indexPath.row]
        return cell
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.HistorySegueIdentifier {
            let searchTableViewController = segue.destination as! TweetTableViewController
            if let recentSearchCell = sender as? UITableViewCell {
                searchTableViewController.searchText = recentSearchCell.textLabel?.text
            }
        }

    }
 

}
