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
    
    
    var imageURL: URL? {
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
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if contentsOfURL != nil {
                            self.image = UIImage(data: contentsOfURL as! Data)
                            
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
