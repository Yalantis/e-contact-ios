//
//  MapSegmentedControl.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 5/30/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

enum MapStateFilters: String {

    case InProgress = "mapFiltersButton.inProgress"
    case Done = "mapFiltersButton.done"
    case Pending = "mapFiltersButton.pending"
    case All = "mapFiltersButton.all"

    static let allFilters = [
        MapStateFilters.InProgress.localized(),
        MapStateFilters.Done.localized(),
        MapStateFilters.Pending.localized(),
        MapStateFilters.All.localized()
        ] as NSArray

    var intValue: [Int] {
        switch self {
        case InProgress:
            return MapStateFilters.inProgressFilter

        case Done:
            return MapStateFilters.doneFilter

        case Pending:
            return MapStateFilters.pendingFilter

        case All:
            return MapStateFilters.allFilers
        }
    }

    private static let inProgressFilter = [Int(TicketStatus.InProgress.rawValue)!]
    private static let doneFilter = [Int(TicketStatus.Done.rawValue)!]
    private static let pendingFilter =  TicketStatus.pendingIdentifiers()
    private static let allFilers: [Int] = {
        var result = inProgressFilter
        result.appendContentsOf(doneFilter)
        result.appendContentsOf(pendingFilter)

        return result
    }()

    init?(localizedValue: String) {
        switch localizedValue {
        case "feedPage.inProgress".localized():
            self = .InProgress

        case "feedPage.done".localized():
            self = .Done

        case "feedPage.pending".localized():
            self = .Pending

        case "mapFiltersButton.all".localized():
            self = .All

        default:
            return nil
        }
    }

}

protocol MapSegmentedControlDelegate {

    func segmentSelected(control: MapSegmentedControl, segment: String)
    func segmentDeselected(control: MapSegmentedControl, segment: String)

}

extension MapSegmentedControlDelegate {

    // for optionals methods
    func segmentSelected(control: MapSegmentedControl, segment: String) { }
    func segmentDeselected(control: MapSegmentedControl, segment: String) { }

}

class MapSegmentedControl: UIView {

    struct Constants {

        static let BorderWidth: CGFloat = 1
        static let ButtonBorderWidth: CGFloat = 0.5
        static let TextColor = UIColor.applicationThemeColor()
        static let BorderColor = UIColor.applicationThemeColor()
        static let Font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        static let AnimationDuration: NSTimeInterval = 0.3
        static let CornerRadius: CGFloat = 4
    }

    internal var delegate: MapSegmentedControlDelegate?
    private var selectedSegments = [String]()
    private var selectedIndexes = [3]
    private var allowMultipleSelection = false

    override func layoutSubviews() {
        layer.cornerRadius = Constants.CornerRadius
        layer.borderWidth = Constants.BorderWidth
        layer.borderColor = Constants.BorderColor.CGColor
        layer.masksToBounds = true

        if self.subviews.count == 0 {
            for  buttonTitle in MapStateFilters.allFilters {
                let index = MapStateFilters.allFilters.indexOfObject(buttonTitle)
                let buttonWidth = frame.width / CGFloat(MapStateFilters.allFilters.count)
                let buttonHeight = frame.height
                let newButton = UIButton(frame: CGRect(x: CGFloat(index) * buttonWidth,
                                                       y: 0,
                                                       width: buttonWidth,
                                                       height: buttonHeight))

                newButton.setTitle((buttonTitle as? String), forState: .Normal)
                newButton.setTitleColor(Constants.TextColor, forState: .Normal)
                newButton.titleLabel?.font = Constants.Font
                newButton.addTarget(self,
                                    action: #selector(MapSegmentedControl.changeSegment(_:)),
                                    forControlEvents: .TouchUpInside)
                newButton.layer.borderWidth = Constants.ButtonBorderWidth
                newButton.layer.borderColor = Constants.BorderColor.CGColor
                newButton.tag = index
                addSubview(newButton)

                for selected in selectedIndexes where selected == index {
                    changeSegment(newButton)
                }
            }
        }
    }

    @objc private func changeSegment(sender: UIButton) {
        if allowMultipleSelection {
            handleSelectionWithMultipleSelectionEnabled(sender)
        } else {
            handleSelectionWithMultipleSelectionDisabled(sender)
        }
    }

    private func handleSelectionWithMultipleSelectionEnabled(sender: UIButton) {
        if sender.backgroundColor == Constants.BorderColor {
            UIView.animateWithDuration(Constants.AnimationDuration,
                animations: {
                    sender.backgroundColor = UIColor.clearColor()
                    sender.setTitleColor(Constants.TextColor, forState: .Normal)
                },
                completion: { [weak self] bool in
                    guard let this = self else {
                        return
                    }
                    for (index, segment) in this.selectedSegments.enumerate() where segment == sender.titleLabel?.text {
                        this.selectedSegments.removeAtIndex(index)
                        this.delegate?.segmentDeselected(this, segment: segment)
                        break
                    }
                })
        } else {
            UIView.animateWithDuration(Constants.AnimationDuration, animations: {
                sender.backgroundColor = Constants.BorderColor
                sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)

                }, completion: { [weak self] bool in
                    guard let this = self else {
                        return
                    }
                    // swiftlint:disable:next force_cast
                    this.selectedSegments.append(MapStateFilters.allFilters[sender.tag] as! String)
                    this.delegate?.segmentSelected(this, segment: sender.titleLabel!.text!)
                })
        }
    }

    private func handleSelectionWithMultipleSelectionDisabled(sender: UIButton) {
        for subview in self.subviews {
            UIView.animateWithDuration(Constants.AnimationDuration) {
                if let button = subview as? UIButton {
                    button.setTitleColor(Constants.TextColor, forState: .Normal)
                    button.backgroundColor = UIColor.clearColor()
                }
            }
        }

        UIView.animateWithDuration(Constants.AnimationDuration) {
            sender.backgroundColor = Constants.BorderColor
            sender.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        delegate?.segmentSelected(self, segment: sender.titleLabel!.text!)
    }

}
