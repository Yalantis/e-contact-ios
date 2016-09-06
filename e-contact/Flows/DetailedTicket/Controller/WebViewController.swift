//
//  WebViewController.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/13/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

final class WebViewController: UIViewController, StoryboardInitable {

    static let storyboardName = "DetailedTicket"

    private var url: NSURL!
    private var router: WebViewControllerRouter!
    @IBOutlet private weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        performRequest()
    }

    // MARK: - Mutators

    func setRouter(router: WebViewControllerRouter) {
        self.router = router
    }

    func setUrl(url: NSURL) {
        self.url = url
    }

    // MARK: - Private methods

    func performRequest() {

        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

}
