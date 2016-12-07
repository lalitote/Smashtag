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
            scrollView.maximumZoomScale = 3.0
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
//            scrollViewDidScroolOrZoom = false
            autozoomToFit()
        }
    }
    
//    private var scrollViewDidScroolOrZoom = false
//    
    func autozoomToFit() {
//        if scrollViewDidScroolOrZoom {
//            return
//        }
        if let sv = scrollView {
            if imageFromTweet != nil {
                sv.zoomScale = max(sv.bounds.size.height / imageFromTweet!.size.height, sv.bounds.size.width / imageFromTweet!.size.width)
//                scrollViewDidScroolOrZoom = false
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autozoomToFit()
    }

//    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
//        scrollViewDidScroolOrZoom = true
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        scrollViewDidScroolOrZoom = true
//    }
//    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageView.image = imageFromTweet
    }


}
