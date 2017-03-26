//
//  WebsiteViewController.swift
//  Smashtag
//
//  Created by lalitote on 13.12.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class WebsiteViewController: UIViewController, UIWebViewDelegate {
    
    
    @IBOutlet weak var websiteVIew: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBAction func stepBack(_ sender: AnyObject) {
        websiteVIew.goBack()
    }
    
    var url: URL? {
        didSet {
            if view.window != nil {
                loadUrl()
            }
        }
    }
    
    fileprivate func loadUrl() {
        if url != nil {
            websiteVIew.loadRequest(URLRequest(url: url!))
        }
    }
    
    var activeDownloads = 0
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activeDownloads += 1
        print(activeDownloads)
        spinner.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activeDownloads -= 1
        if activeDownloads < 1 {
            spinner.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        websiteVIew.scalesPageToFit = true
        websiteVIew.delegate = self
        loadUrl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
