//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by lalitote on 23.11.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            let attributedString = NSMutableAttributedString(string: (tweet.text))
                
            if tweetTextLabel?.text != nil {
                
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                for hashtag in tweet.hashtags {
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 208/255, green: 136/255, blue: 2/255, alpha: 1.0), range: hashtag.nsrange)
               }
                for user in tweet.userMentions {
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 200/255, green: 12/255, blue: 47/255, alpha: 1.0), range: user.nsrange)
                }
                for url in tweet.urls {
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 172/255, green: 187/255, blue: 42/255, alpha: 1.0), range: url.nsrange)
                }
                tweetTextLabel.attributedText = attributedString
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOf: profileImageURL) { // blocks main thread
                    tweetProfileImageView?.image = UIImage(data: imageData as Data)
                }
            }
            
            let formatter = DateFormatter()
            if NSDate().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
        }
    }
    
}
