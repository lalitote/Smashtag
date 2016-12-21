//
//  ImagesCollectionViewController.swift
//  Smashtag
//
//  Created by lalitote on 20.12.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit
import Twitter

private let reuseIdentifier = "Cell"

class ImagesCollectionViewController: UICollectionViewController {
    
    var images = [TweetMedia]()
    
    struct TweetMedia {
        var tweet: Tweet
        var media: MediaItem
        
        var description: String {
            return "\(tweet): \(media)"
        }
    }
    
    var tweets = [Array<Tweet>]() {
        didSet {
            images = tweets.reduce([], +).map { tweet in tweet.media.map { TweetMedia(tweet: tweet, media: $0) } }.reduce([], +)
        }
    }
    
    private struct Storyboard {
        static let CellIdentifier = "Image From Search"
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.darkGray
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
