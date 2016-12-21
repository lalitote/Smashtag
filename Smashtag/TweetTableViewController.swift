//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by lalitote on 22.11.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: Model
    
    var tweets = [Array<Tweet>]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var searchText: String? {
        didSet {
            tweets.removeAll()
            lastTwitterRequest = nil
            searchForTweets()
            title = searchText
            RecentSearches().add(search: searchText!)
        }
    }
    
    // MARK: Fetching Tweets
    
    private var twitterRequest: Twitter.Request? {
        if lastTwitterRequest == nil {
            if var query = searchText, !query.isEmpty {
                if query.hasPrefix("@") {
                    query = "\(query) OR from:\(query)"
                }
                return Twitter.Request(search: query + " -filter:retweets", count: 100)
            }
        }
        return lastTwitterRequest?.requestForNewer
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest {
            lastTwitterRequest = request
            request.fetchTweets{ [weak weakSelf = self] newTweets in
                DispatchQueue.main.async {
                    if request == weakSelf?.lastTwitterRequest {
                        if !newTweets.isEmpty {
                            weakSelf?.tweets.insert(newTweets, at: 0)
                        }
                    }
                    weakSelf?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }

    @IBAction func refresh(_ sender: UIRefreshControl) {
        if searchText != nil {
            RecentSearches().add(search: searchText!)
        }
        searchForTweets()
    }

    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(tweets.count - section)"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TweetCellIdentifier, for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }

        return cell
    }
    
    // MARK: Constants
    
    fileprivate struct Storyboard {
        static let TweetCellIdentifier = "Tweet"
        static let ShowMentionSegue = "ShowMentionsSegue"
        static let ShowImagesIdentifier = "Show Images"
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    // MARK: UITextDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
    
    // MARK: View Controller Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                navigationItem.rightBarButtonItem = nil
            }
        }
        let imagesButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(showImages(sender:)))
        if let existingButton = navigationItem.rightBarButtonItem {
            navigationItem.rightBarButtonItems = [existingButton, imagesButton]
        } else {
            navigationItem.rightBarButtonItem = imagesButton
        }
    }

    func showImages(sender: UIBarButtonItem) {
        performSegue(withIdentifier: Storyboard.ShowImagesIdentifier, sender: sender)
    }
    
    
    // MARK: - Navigation
    
    @IBAction func unwindToRoot(segue: UIStoryboardSegue) {}
    
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        if let first = navigationController?.viewControllers.first as? TweetTableViewController {
            if first == self {
                return true
            }
        }
        return false
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.ShowMentionSegue {
            if let tweetCell = sender as? TweetTableViewCell {
                let tweetContent = (tweetCell.tweet?.hashtags.count)! + (tweetCell.tweet?.urls.count)! + (tweetCell.tweet?.userMentions.count)! + (tweetCell.tweet?.media.count)!
                if tweetContent == 0 {
                    return false
                }
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowMentionSegue {
            let mentionsDetailTableViewController = segue.destination as! MentionsTableViewController
            
            // Get the cell that generated this segue
            if let selectedTweetCell = sender as? TweetTableViewCell {
                mentionsDetailTableViewController.tweet = selectedTweetCell.tweet
            }
        } else if segue.identifier == Storyboard.ShowImagesIdentifier {
            if let icvc = segue.destination as? ImagesCollectionViewController {
                icvc.tweets = tweets
                icvc.title = "Images: \(searchText!)"
            }
        }
    }
    

}
