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
    
    var tweet: Tweet?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let tweet = tweet {
            title = tweet.user.name
        }
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        sections = [
            Section(type: .Images, mentions: (tweet?.media)!),
            Section(type: .Hashtags, mentions: (tweet?.hashtags)!),
            Section(type: .Urls, mentions: (tweet?.urls)!),
            Section(type: .Users, mentions: (tweet?.userMentions)!)
        ]
    }
    
    private enum SectionType {
        case Images
        case Hashtags
        case Urls
        case Users
        
        func header() -> String {
            switch self {
            case .Images: return "Images"
            case .Hashtags: return "Hashtags"
            case .Urls: return "Urls"
            case .Users: return "Users"
            }
        }
    }
    
//    private enum Mention {
//        case Image
//        case Url(String)
//        case Hashtag
//        case UserMention
//    }
    
    private struct Section {
        var type: SectionType
        var mentions: [NSObject]
    }
    
    
    private var sections = [Section]()
    

    private struct Storyboard {
        static let MentionsCellIdentifier = "Mention"
        static let ImageCellIdentifier = "Image"
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].type.header()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].mentions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String
        
        // Switching through each section and row to set appropriate identifier
        switch sections[indexPath.section].type {
        case .Images:
            cellIdentifier = Storyboard.ImageCellIdentifier
        case .Hashtags, .Urls, .Users:
            cellIdentifier = Storyboard.MentionsCellIdentifier
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let mentionToLoad = sections[indexPath.section].mentions[indexPath.row]
        cell.textLabel?.text = String(describing: mentionToLoad)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
