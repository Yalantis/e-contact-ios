
import Foundation
import UIKit
import QuartzCore

class AppearanceApplyingStrategy {
    
    func apply(
        appearance: Appearance?,
        toNavigationController navigationController: UINavigationController,
        navigationItem: UINavigationItem?,
        animated: Bool
        ) {
            if let appearance = appearance {
                let navigationBar = navigationController.navigationBar
                let toolbar = navigationController.toolbar
                
                if !navigationController.navigationBarHidden {
                    navigationBar.tintColor = appearance.navigationBar.tintColor
                    navigationBar.barTintColor = appearance.navigationBar.barTintColor
                    navigationBar.shadowImage = appearance.navigationBar.shadowImage
                    navigationBar.translucent = appearance.navigationBar.translucent
                    navigationBar.titleTextAttributes = [
                        NSForegroundColorAttributeName: UIColor.blackColor()
                    ]
                }
                
                if !navigationController.toolbarHidden {
                    toolbar.tintColor = appearance.toolbar.tintColor
                    toolbar.barTintColor = appearance.toolbar.barTintColor
                }
            }
    }
    
}