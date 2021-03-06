//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by lalitote on 25.11.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    var tweet: Tweet? {
        didSet {
            title = tweet?.user.name
            
            if let media = tweet?.media {
                if media.count > 0 {
                    mentions.append(Section(title: "Images", data: media.map{ MentionItem.image($0.url, $0.aspectRatio) }))
                }
            }
            if let url = tweet?.urls {
                if url.count > 0 {
                    mentions.append(Section(title: "Urls", data: url.map { MentionItem.otherMention($0.keyword) }))
                }
            }
            if let hashtag = tweet?.hashtags {
                if hashtag.count > 0 {
                    mentions.append(Section(title: "Hashtags", data: hashtag.map { MentionItem.otherMention($0.keyword) } ))
                }
            }
            if let user = tweet?.userMentions {
                var usersInTweet = [MentionItem.otherMention("@" + (tweet?.user.name)!)]
                if user.count > 0 {
                    usersInTweet += user.map { MentionItem.otherMention($0.keyword) }
                    // mentions.append(Section(title: "Users", data: user.map { MentionItem.OtherMention($0.keyword)}))
                }
                mentions.append(Section(title: "Users", data: usersInTweet))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate enum MentionItem {
        case image(URL, Double)
        // Hashtags, Urls, User mentions
        case otherMention(String)
    }
    
    fileprivate struct Section {
        var title: String
        var data: [MentionItem]
    }
    
    fileprivate var mentions = [Section]()
    
    fileprivate struct Storyboard {
        static let MentionsCellIdentifier = "Mention Cell"
        static let ImageCellIdentifier = "Image Cell"
        static let MentionSearchIdentifier = "Mention Search Segue"
        static let ShowImageIdentifier = "Show Image"
        static let ShowWebsiteIdentifier = "Show Website"
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return mentions[section].title
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].data.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].data[indexPath.row]
        switch mention {
        case .otherMention(let otherMention):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.MentionsCellIdentifier, for: indexPath) as UITableViewCell
            cell.textLabel?.text = otherMention
            return cell
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.ImageCellIdentifier, for: indexPath) as! ImageTableViewCell
            cell.imageURL = url
            return cell
        }
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Storyboard.MentionSearchIdentifier {
            if let mentionCell = sender as? UITableViewCell {
                if let url = mentionCell.textLabel?.text {
                    if url.hasPrefix("http") {
//                        let urlToLoad = URL(string: url)!
//                        UIApplication.shared.open(urlToLoad, options: [:], completionHandler: nil)
                        performSegue(withIdentifier: Storyboard.ShowWebsiteIdentifier, sender: sender)
                        return false
                    }
                }
            }
        }
        if identifier == Storyboard.ShowImageIdentifier {
            if let mentionCell = sender as? ImageTableViewCell {
                if mentionCell.tweetImage.image == nil {
                    return false
                }
            }
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.MentionSearchIdentifier {
            let mentionSearchTableViewController = segue.destination as! TweetTableViewController
            if let selectedMention = sender as? UITableViewCell {
                mentionSearchTableViewController.searchText = selectedMention.textLabel?.text
            }
        }
        else if segue.identifier == Storyboard.ShowImageIdentifier {
            let imageViewController = segue.destination as! ImageViewController
            if let imageCell = sender as? ImageTableViewCell {
                imageViewController.imageFromTweet = imageCell.tweetImage.image
                imageViewController.title = title
            }
        }
        else if segue.identifier == Storyboard.ShowWebsiteIdentifier {
            let websiteViewController = segue.destination as? WebsiteViewController
            if let selectedMention = sender as? UITableViewCell {
                if let urlFromTweet = selectedMention.textLabel?.text {
                    websiteViewController?.url = URL(string: urlFromTweet)
                }
            }
        }
    }
    

}
