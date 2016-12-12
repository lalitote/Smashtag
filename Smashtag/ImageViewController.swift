//
//  ImageViewController.swift
//  Smashtag
//
//  Created by lalitote on 04.12.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.3
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    var imageView = UIImageView()
    
    var imageFromTweet: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            autozoomToFit()
        }
    }
    
    func autozoomToFit() {
        if let sv = scrollView {
            if imageFromTweet != nil {
                sv.zoomScale = max(sv.bounds.size.height / imageFromTweet!.size.height, sv.bounds.size.width / imageFromTweet!.size.width)
                sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2, y: (imageView.frame.size.height - sv.frame.size.height) / 2)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autozoomToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageView.image = imageFromTweet
    }


}
