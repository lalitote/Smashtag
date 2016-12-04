//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by lalitote on 02.12.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    
    func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = NSData(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.tweetImage.image = UIImage(data: imageData as Data)
                            
                        } else {
                            self.tweetImage?.image = nil
                        }
                        self.spinner?.stopAnimating()
                    }
                    
                }
            }
        }
    }
    
}
