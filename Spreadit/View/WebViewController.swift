//
//  WebViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 20/02/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class WebViewController: BNDViewController, UIWebViewDelegate {

    @IBOutlet var webView: UIWebView!
    var activityIndicator: UIActivityIndicatorView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.webView.addSubview(activityIndicator!)
        activityIndicator!.center = self.webView.center
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.webView.loadRequest(webViewModel().request())
    }

    func webViewModel() -> WebViewModel {
        return self.viewModel as! WebViewModel
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator!.stopAnimating()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator!.startAnimating()
    }
}
