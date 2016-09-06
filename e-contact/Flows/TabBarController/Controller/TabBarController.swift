//  e-contact
//
//  Created by Igor Muzyka on 3/17/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum TabBarControllerManaged: Int {

    case FeedViewController = 0
    case ProfileViewController

}

protocol LoginDisplayable {

    func displayLogin()

}

final class TabBarController: UITabBarController, StoryboardInitable, TabBarViewDelegate {

    static let storyboardName = "TabBarController"

    @IBOutlet internal var tabBarView: TabBarView!

    private  var router: TabBarControllerRouter!
    private weak var locator: ServiceLocator!

    // MARK: - init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configureTabBar()
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarView.delegate = self
        router.switchToFeed(self)
    }

    // MARK: - Layout

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarView()
    }

    // MARK: - Setup

    private func configureTabBar() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }

    private func setupTabBarView() {
        for view in tabBar.subviews {
            view.removeFromSuperview()
        }

        tabBarView.frame = tabBar.bounds
        tabBarView.center = tabBar.center
        view.addSubview(tabBarView)
    }

    // MARK: - Mutators

    func setLocator(locator: ServiceLocator) {
        self.locator = locator
    }

    func setRouter(router: TabBarControllerRouter) {
        self.router = router
    }

    // MARK: - TabBarViewDelegate

    func tabBarSelectedFeed() {
        router.switchToFeed(self)
    }

    func tabBarSelectedProfile() {
        if User.currentUser() != nil {
            router.switchToProfile(self)
            return
        }
        guard let controller = getSelectedControllerWithLoginDisplayableProtocol() else { return }

        controller.displayLogin()
    }

    func tabBarSelectedNewTicket() {
        if User.currentUser() != nil {
            router.showTicketCreation(tabBarController: self)
            return
        }
        guard let controller = getSelectedControllerWithLoginDisplayableProtocol() else { return }

        controller.displayLogin()
    }

    // MARK: - PrivateMethods

    private func getSelectedControllerWithLoginDisplayableProtocol() -> LoginDisplayable? {
        guard let navigationController = selectedViewController as? AppearanceNavigationController,
            controller = navigationController.topViewController as? LoginDisplayable else {
                return nil
        }
        return controller
    }

}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if let index = tabBarController.viewControllers?.indexOf(viewController),
            controllerType = TabBarControllerManaged(rawValue: index) {
            switch controllerType {
            case TabBarControllerManaged.FeedViewController:
                tabBarView.setFeedSelected()
            case TabBarControllerManaged.ProfileViewController:
                tabBarView.setProfileSelected()
            }
        }
    }

}

extension TabBarController: NavigationControllerAppearanceContext {

    func preferredNavigationControllerAppearance(navigationController: UINavigationController) -> Appearance? {
        return Appearance()
    }

}
