
import Foundation
import UIKit

struct Appearance: Equatable {
    
    struct Bar: Equatable {
        
        var style: UIBarStyle = .Default
        var backgroundColor = UIColor.whiteColor()
        var tintColor = UIColor.applicationThemeColor()
        var barTintColor = UIColor.whiteColor()
        var shadowImage: UIImage?
        var translucent: Bool = false
    }
    
    var titleViewAlpha: CGFloat = 1
    
    var statusBarStyle: UIStatusBarStyle = .Default
    var navigationBar = Bar()
    var toolbar = Bar()
}

func ==(lhs: Appearance.Bar, rhs: Appearance.Bar) -> Bool {
    return lhs.style == rhs.style &&
        lhs.backgroundColor == rhs.backgroundColor &&
        lhs.tintColor == rhs.tintColor &&
        lhs.barTintColor == rhs.barTintColor
}

func ==(lhs: Appearance, rhs: Appearance) -> Bool {
    return lhs.statusBarStyle == rhs.statusBarStyle &&
        lhs.navigationBar == rhs.navigationBar &&
        lhs.toolbar == rhs.toolbar
}