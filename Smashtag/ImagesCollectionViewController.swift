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

class ImagesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
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
    
    var cache = NSCache<NSURL, NSData>()
    
    var scale: CGFloat = 1.0 { didSet {collectionView?.collectionViewLayout.invalidateLayout()} }
    
    private struct Storyboard {
        static let CellIdentifier = "Image From Search"
        static let CellArea: CGFloat = 4000
        static let ShowTweetsSegue = "Tweet From Image"
    }
    
    
    func zoom(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            scale *= recognizer.scale
            recognizer.scale = 1.0
        }
    }
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(ImagesCollectionViewController.zoom(_:))))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.ShowTweetsSegue {
            if let ttvc = segue.destination as? TweetTableViewController {
                if let cell = sender as? ImageCollectionViewCell {
                ttvc.tweets = [[images[(collectionView?.indexPath(for: cell)!.row)!].tweet]]
                }
            }
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.CellIdentifier, for: indexPath) as! ImageCollectionViewCell
        
        cell.cache = cache
        cell.imageURL = images[indexPath.row].media.url as NSURL
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt: IndexPath) -> CGSize {
        let ratio = CGFloat(images[sizeForItemAt.row].media.aspectRatio)
        let width = min(sqrt(ratio * Storyboard.CellArea) * scale, (collectionView?.bounds.size.width)!)
        let height = width / ratio
        return CGSize(width: width, height: height)
    }

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
