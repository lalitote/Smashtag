//
//  ImageCollectionViewCell.swift
//  Smashtag
//
//  Created by lalitote on 20.12.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var cache: NSCache<NSURL, NSData>?
    
    var imageURL: NSURL? {
        didSet {
            backgroundColor = UIColor.darkGray
            image = nil
            fetchImage()
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        } set {
            imageView.image = newValue
            spinner?.stopAnimating()
        }
    }
    
    func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            
            var imageData = cache?.object(forKey: imageURL!)
            if imageData != nil {
                self.image = UIImage(data: imageData! as Data)
                return
            }
            DispatchQueue.global(qos: .userInitiated).async {
                imageData = NSData(contentsOf: url as URL)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.image = UIImage(data: imageData as! Data)
                            self.cache?.setObject(imageData!, forKey: self.imageURL!, cost: imageData!.length / 1024)
                        } else {
                            self.image = nil
                        }
//                        self.spinner?.stopAnimating()
                    }
                    
                }
            }
        }
    }
}
