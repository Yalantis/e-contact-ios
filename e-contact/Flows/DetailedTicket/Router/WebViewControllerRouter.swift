//
//  WebViewControllerRouter.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/13/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit


class WebViewControllerRouter: AlertManagerDelegate {

    private(set) var url: NSURL!
    private(set) weak var locator: ServiceLocator!
    private(set) weak var currentViewController: UIViewController!

    init(locator: ServiceLocator, url: NSURL) {
        self.locator = locator
        self.url = url
    }

}

extension WebViewControllerRouter: Router {

    func execute(context: UINavigationController) -> AnyObject? {
        let controller = WebViewController.create()
        controller.setRouter(self)
        controller.setUrl(url)
        currentViewController = controller
        context.showViewController(controller, sender: self)

        return nil
    }

}

protocol WebViewControllerPresenter: NavigationProtocol {

    func showWebView(url: NSURL)

}

extension WebViewControllerPresenter {

    func showWebView(url: NSURL) {
        let router = WebViewControllerRouter(locator: locator, url: url)

        router.execute(currentViewController.navigationController!)
    }

}
