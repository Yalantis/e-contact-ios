//
// Created by zen on 17/03/15.
// Copyright (c) 2015 KustomNote. All rights reserved.
//

import Foundation
import UIKit

class ScrollViewKeyboardController: NSObject, UIGestureRecognizerDelegate {
    
    private var keyboardShown = false
    
    private var oldContentInset: UIEdgeInsets?
    private var oldScrollIndicatorInsets: UIEdgeInsets?
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    private lazy var gestureRecognizer: UIGestureRecognizer = { [unowned self] in
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ScrollViewKeyboardController.touchDownRecognized(_:)))
        recognizer.delegate = self
        
        return recognizer
    }()
        
    @IBOutlet var scrollView: UIScrollView! {
        willSet {
            NSNotificationCenter.defaultCenter().removeObserver(self)
        }
        didSet {
            oldValue?.removeGestureRecognizer(gestureRecognizer)
            
            if scrollView != nil {
                let center = NSNotificationCenter.defaultCenter()
                center.addObserver(self, selector: #selector(ScrollViewKeyboardController.keyboardWillShown(_:)), name:UIKeyboardWillShowNotification, object: nil)
                center.addObserver(self, selector: #selector(ScrollViewKeyboardController.keyboardWillBeHidden(_:)), name:UIKeyboardWillHideNotification, object: nil)
                
                center.addObserver(
                    self,
                    selector: #selector(UITextFieldDelegate.textFieldDidBeginEditing(_:)),
                    name: UITextFieldTextDidBeginEditingNotification,
                    object: nil
                )
                
                scrollView.addGestureRecognizer(gestureRecognizer)
            }
        }
    }
    
    @objc private func keyboardWillShown(notification: NSNotification) {
        if keyboardShown == true {
            return
        }
        let info = notification.userInfo!
        let keyboardFrame = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        if scrollView != nil {
            oldContentInset = scrollView.contentInset
            oldScrollIndicatorInsets = scrollView.scrollIndicatorInsets
            let insets = UIEdgeInsets(top: 64, left: 0, bottom: keyboardFrame!.size.height, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            
            keyboardShown = true
        }
    }
    
    @objc private func keyboardWillBeHidden(notification: NSNotification) {
        if keyboardShown == false {
            return
        }
        guard let oldContentInset = oldContentInset, oldScrollIndicatorInsets = oldScrollIndicatorInsets else {
            var insets = UIEdgeInsetsZero
            insets.top = 64
            scrollView!.contentInset = insets;
            scrollView!.scrollIndicatorInsets = insets;

            keyboardShown = false
            return
        }
        
        scrollView!.contentInset = oldContentInset;
        scrollView!.scrollIndicatorInsets = oldScrollIndicatorInsets;
    
        keyboardShown = false
    }
    
    @objc private func textFieldDidBeginEditing(notification: NSNotification) {
        if let textField = notification.object as? UITextField where scrollView != nil && textField.isDescendantOfView(scrollView!) {
            let frame = scrollView.convertRect(textField.bounds, fromView: textField)
            scrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
    @objc private func touchDownRecognized(sender: UIGestureRecognizer) {
        scrollView.endEditing(true)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let isControl = touch.view is UIControl || touch.view is UITextView || touch.view!.superview is UITableViewCell
        return keyboardShown && !isControl
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
