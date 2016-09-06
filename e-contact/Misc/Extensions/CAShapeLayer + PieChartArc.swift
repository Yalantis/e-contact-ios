//
//  CAShapeLayer + PieChartArc.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension CAShapeLayer {

    // swiftlint:disable function_parameter_count
    convenience init(centrePoint: CGPoint,
                     radius: CGFloat,
                     startAngle: CGFloat,
                     endAngle: CGFloat,
                     strokeColor: UIColor,
                     lineWidth: CGFloat) {
        self.init()

        let angle = (endAngle - Constants.PieChart.Separator) < startAngle ?
            endAngle :
            endAngle - Constants.PieChart.Separator

        let arcPath = UIBezierPath(arcCenter: centrePoint,
                                   radius: radius,
                                   startAngle: startAngle,
                                   endAngle: angle, clockwise: true)
        self.strokeColor = strokeColor.CGColor
        self.lineWidth = lineWidth
        self.path = arcPath.CGPath
        self.fillColor = UIColor.clearColor().CGColor
        self.opacity = Constants.PieChart.ArcOpacity
    }

}
