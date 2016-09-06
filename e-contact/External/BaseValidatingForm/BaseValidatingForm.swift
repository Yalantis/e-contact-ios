//
//  BaseValidatingForm.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 6/23/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

typealias TextFormatingAfterEdditing = (UITextField) -> (Void)
typealias TextFormatingActionWhileEditing = (textField: UITextField, range: NSRange, string: String) -> (Bool)

protocol ValidatingFormDelegate {
    
    func validatingFormDidShowError(validatingForm: BaseValidatingForm)
    func validatingFormDidHideError(validatingForm: BaseValidatingForm)
    func validatingFormTextFieldShouldReturn(validatingForm: BaseValidatingForm) -> Bool
    func validatingFormTextFieldDidEndEditing(validatingForm: BaseValidatingForm)
    
}

extension ValidatingFormDelegate {
    
    func validatingFormDidShowError(validatingForm: BaseValidatingForm) {}
    func validatingFormDidHideError(validatingForm: BaseValidatingForm) {}
    func validatingFormTextFieldShouldReturn(validatingForm: BaseValidatingForm) -> Bool { return true }
    func validatingFormTextFieldDidEndEditing(validatingForm: BaseValidatingForm) {}
    
}

@IBDesignable class BaseValidatingForm: UIView {
    
    var textFormatingAfterEdditing: TextFormatingAfterEdditing?
    var textFormatingWhileEdditing: TextFormatingActionWhileEditing?
    var delegate: ValidatingFormDelegate?
    
    var height: CGFloat {
        var value: CGFloat = 0.0
        for constraint in formVerticalConstraints {
            value += constraint.constant
        }
        return value
    }
    var validationParameters: ValidationParameters {
        return ValidationParametersSet.None()
    }
    var text: String? {
        get {
            return textField.text
        }
        set(text) {
            textField.text = text
        }
    }
    
    private var view: UIView!
    private var errorHidden = false
    @IBOutlet private var textField: RoundedTextField!
    @IBOutlet private var errorLabel: UILabel!
    @IBOutlet private var errorLabelHeight: NSLayoutConstraint!
    @IBOutlet private var formVerticalConstraints: [NSLayoutConstraint]!
    @IBOutlet private var heightConstraint: NSLayoutConstraint?
    
    @IBInspectable var errorTitle: String? {
        get {
            return errorLabel.text
        }
        set(errorTitle) {
            errorLabel.text = errorTitle
        }
    }
    
    @IBInspectable var textFieldPlaceHolder: String? {
        get {
            return textField.placeholder
        }
        set(textFieldPlaceHolder) {
            textField.placeholder = textFieldPlaceHolder
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else {
            return
        }
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        addSubview(view)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[view]-(0)-|", options: [], metrics: nil, views: ["view": view]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[view]-(0)-|", options: [], metrics: nil, views: ["view": view]))
        self.view = view
        setup()
    }
    
    internal func setup() {
        errorTitle = validationParameters.message
        hideError()
    }
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }

    override func isFirstResponder() -> Bool {
        return textField.isFirstResponder()
    }

    func hasValidContent() -> Bool {
        return TextValidationHelper.validateText(textField.text, parameters: validationParameters, withAlert: false)
    }
    
    func showError() {
        if errorHidden {
            toggleError()
        }
    }
    
    func hideError() {
        if !errorHidden {
            toggleError()
        }
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "BaseValidatingForm", bundle: bundle)
        guard let view = nib.instantiateWithOwner(self, options: [:]).first as? UIView else {
            return nil
        }
        return view
    }
    
    private func toggleError() {
        layoutIfNeeded()
        let constant: CGFloat = (errorHidden) ? errorLabel.sizeThatFits(CGSizeMake(errorLabel.frame.width, CGFloat.max)).height : 0.0
        errorLabelHeight.constant = constant
        heightConstraint?.constant = height
        (errorHidden) ? delegate?.validatingFormDidShowError(self) : delegate?.validatingFormDidHideError(self)
        textField.setStateValidated(!errorHidden)
        errorHidden = !errorHidden
    }
}

extension BaseValidatingForm: UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        textFormatingAfterEdditing?(textField)
        
        hasValidContent() ? hideError() : showError()
        
        delegate?.validatingFormTextFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let delegate = delegate {
            return delegate.validatingFormTextFieldShouldReturn(self)
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let action = textFormatingWhileEdditing {
            return action(textField: textField, range: range, string: string)
        }
        return true
    }
    
}

class EmailValidatingForm: BaseValidatingForm {
    
    override var validationParameters: ValidationParameters {
        return ValidationParametersSet.Email()
    }
    
    override func setup() {
        super.setup()
        
        setTextFieldKeyboardParameters()
    }
    
    func setTextFieldKeyboardParameters() {
        textField.keyboardType = .EmailAddress
    }
    
}

class FirstNameValidatingForm: BaseValidatingForm {
    
    override var validationParameters: ValidationParameters {
        return ValidationParametersSet.FirstName()
    }
    
}

class LastNameValidatingForm: BaseValidatingForm {
    
    override var validationParameters: ValidationParameters {
        return ValidationParametersSet.LastName()
    }
    
}

class MiddleNameValidatingForm: BaseValidatingForm {
    
    override var validationParameters: ValidationParameters {
        return ValidationParametersSet.MiddleName()
    }
    
}

class PasswordValidatingForm: BaseValidatingForm {
    
    override var validationParameters: ValidationParameters {
        return ValidationParametersSet.Password()
    }
    
    override func setup() {
        super.setup()
        
        setTextFieldKeyboardParameters()
    }
    
    func setTextFieldKeyboardParameters() {
        textField.secureTextEntry = true
    }
    
}

class LastPasswordValidatingForm: PasswordValidatingForm {
    
    override func setTextFieldKeyboardParameters() {
        super.setTextFieldKeyboardParameters()
        textField.returnKeyType = .Done
    }
    
}

class LastEmailValidatingForm: EmailValidatingForm {
    
    override func setTextFieldKeyboardParameters() {
        super.setTextFieldKeyboardParameters()
        textField.returnKeyType = .Done
    }
    
}
