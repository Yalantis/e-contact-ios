//
//  UIView+PieChart.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 4/18/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIView {

    // MARK: - Class methods

    static func holePieChartWith(clusterContent: [GeoTicket]) -> UIView {

        var sizeMultiplier: CGFloat = 1

        if clusterContent.count > Int(Constants.PieChart.ClusterSize) {
            sizeMultiplier += 0.5
        } else {
            sizeMultiplier += CGFloat(clusterContent.count) / (Constants.PieChart.ClusterSize * 2)
        }

        let view = UIView(frame:
            CGRect(x: 0,
                y: 0,
                width: Constants.PieChart.ClusterSize * sizeMultiplier,
                height: Constants.PieChart.ClusterSize * sizeMultiplier)
        )

        view.configurePieChartView(sizeMultiplier, clusterContent: clusterContent)

        return view
    }

    // MARK: - Private methods

    private func configurePieChartView(sizeMultiplier: CGFloat, clusterContent: [GeoTicket]) {
        self.backgroundColor = UIColor.clearColor()

        self.layer.addSublayer(self.createCircleLayerWithMultiplier(sizeMultiplier))
        self.layer.addSublayer(self.createTextLayerWithMultiplier(sizeMultiplier, text: String(clusterContent.count)))

        self.setArcsWithClusterContent(clusterContent, sizeMultiplier: sizeMultiplier)
    }

    private func createCircleLayerWithMultiplier(sizeMultiplier: CGFloat) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.whiteColor().CGColor
        circleLayer.opacity = 0.5 / Float(sizeMultiplier)
        circleLayer.path = UIBezierPath(ovalInRect:
            CGRect(x: 0,
                y: 0,
                width: Constants.PieChart.ClusterSize * sizeMultiplier,
                height: Constants.PieChart.ClusterSize * sizeMultiplier)
            ).CGPath

        return circleLayer
    }

    private func createTextLayerWithMultiplier(sizeMultiplier: CGFloat, text: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.allowsFontSubpixelQuantization = true
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.fontSize = Constants.PieChart.TextleLayerHeight * sizeMultiplier
        textLayer.contentsScale = Constants.Scale
        textLayer.frame = CGRect(x: 0, y: (Constants.PieChart.TextleLayerHeight + 1) * sizeMultiplier,
                                 width: Constants.PieChart.ClusterSize * sizeMultiplier,
                                 height: Constants.PieChart.TextleLayerHeight * sizeMultiplier)
        textLayer.alignmentMode = kCAAlignmentCenter

        return textLayer
    }

    private func setArcsWithClusterContent(clusterContent: [GeoTicket], sizeMultiplier: CGFloat) {

        let radius: CGFloat = Constants.PieChart.ClusterSize * Constants.PieChart.ArcRadiusReducer * sizeMultiplier
        let lineWidth: CGFloat = radius / 2

        let clusterCounters = self.clusterCountersForContent(clusterContent)

        let π = CGFloat(M_PI)
        var startAngle: CGFloat = 0

        if clusterCounters.pendingCounter > 0 {
            let endAngle = CGFloat(clusterCounters.pendingCounter) / CGFloat(clusterContent.count) * π * 2
            let pendingLayer = CAShapeLayer(centrePoint: center, radius: radius, startAngle: startAngle,
                                            endAngle: endAngle, strokeColor: UIColor.pendingColor(),
                                            lineWidth: lineWidth)
            startAngle = endAngle
            self.layer.addSublayer(pendingLayer)
        }

        if clusterCounters.inProgressCounter > 0 {
            let endAngle = (
                CGFloat(clusterCounters.inProgressCounter) / CGFloat(clusterContent.count) * π * 2) + startAngle
            let inProgressLayer = CAShapeLayer(centrePoint: center, radius: radius, startAngle: startAngle,
                                               endAngle: endAngle, strokeColor: UIColor.inProgressColor(),
                                               lineWidth: lineWidth)
            startAngle = endAngle
            self.layer.addSublayer(inProgressLayer)
        }

        if clusterCounters.doneCounter > 0 {
            let endAngle = (CGFloat(clusterCounters.doneCounter) / CGFloat(clusterContent.count) * π * 2) + startAngle
            let doneLayer = CAShapeLayer(centrePoint: center, radius: radius, startAngle: startAngle,
                                         endAngle: endAngle, strokeColor: UIColor.doneColor(), lineWidth: lineWidth)
            self.layer.addSublayer(doneLayer)
        }
    }

    private func clusterCountersForContent(clusterContent: [GeoTicket]) -> (pendingCounter: Int, inProgressCounter: Int,
        doneCounter: Int) {
            var pendingCounter = 0
            var inProgressCounter = 0
            var doneCounter = 0

            for ticket in clusterContent {
                guard let ticketState = TicketStateId(rawValue: ticket.stateIdentifier) else {
                    continue
                }
                switch ticketState {
                case TicketStateId.Moderation, TicketStateId.Denied, TicketStateId.Accepted, TicketStateId.OnReview:
                    pendingCounter += 1

                case TicketStateId.InWork:
                    inProgressCounter += 1

                case TicketStateId.Done:
                    doneCounter += 1
                }
            }

            return (pendingCounter, inProgressCounter, doneCounter)
    }

}
