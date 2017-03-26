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
    
    var hashtagColor = UIColor(red: 208/255, green: 136/255, blue: 2/255, alpha: 1.0)
    var urlColor = UIColor(red: 172/255, green: 187/255, blue: 42/255, alpha: 1.0)
    var userMentionColor = UIColor(red: 200/255, green: 12/255, blue: 47/255, alpha: 1.0)
    var mediaColor = UIColor(red: 172/255, green: 187/255, blue: 42/255, alpha: 1.0)
    
    fileprivate func updateUI() {
        
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet {

            var text = tweet.text
            
            for _ in tweet.media {
                text += " 📷"
            }
            
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.changeMentionsColor(tweet.hashtags, color: hashtagColor)
            attributedText.changeMentionsColor(tweet.urls, color: urlColor)
            attributedText.changeMentionsColor(tweet.userMentions, color: userMentionColor)
            tweetTextLabel?.attributedText = attributedText
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                DispatchQueue.global(qos: .userInitiated).async {
                    let contentOfUrl = NSData(contentsOf: profileImageURL)
                    DispatchQueue.main.async {
                        if profileImageURL == tweet.user.profileImageURL {
                            if let imageData = contentOfUrl {
                                self.tweetProfileImageView?.image = UIImage(data: imageData as Data)
                            }
                        }
                        
                    }
                }
            }
            
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweet.created) > 24*60*60 {
                formatter.dateStyle = DateFormatter.Style.short
            } else {
                formatter.timeStyle = DateFormatter.Style.short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweet.created)
            
            if tweet.hashtags.count + tweet.urls.count + tweet.userMentions.count + tweet.media.count > 0 {
                accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            } else {
                accessoryType = UITableViewCellAccessoryType.none
                
            }
        }
    }
    
}

// MARK: Extensions

private extension NSMutableAttributedString {
    func changeMentionsColor(_ mentions: [Mention], color: UIColor) {
        for mention in mentions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
}
