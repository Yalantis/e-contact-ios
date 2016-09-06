//
//  NSDate + StringFromDate.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/21/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension NSDate {

    func dateString() -> String {
        let days = self.daysBetweenDate(self, andDate: NSDate())
        var dayString = ""
        if days == 0 {
            dayString = "detailedTicket.date.string.today".localized()
        } else if days == 1 {
            dayString = "detailedTicket.date.string.yesterday".localized()
        }

        var resultString: String

        if dayString != "" {
            resultString = "\(dayString)\(Constants.HoursMinutesDateFormatter.stringFromDate(self))"
        } else {
            resultString = Constants.MonthDateDateFormatter.stringFromDate(self)
        }
        return resultString
    }

    private func daysBetweenDate(fromDateTime: NSDate, andDate toDateTime: NSDate) -> Int {
        var fromDate: NSDate?
        var toDate: NSDate?
        fromDate = NSDate()
        toDate = NSDate()

        let calendar = NSCalendar.currentCalendar()
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: .WrapComponents)
        return difference.day
    }

}
