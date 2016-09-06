//
//  MapModel.swift
//  e-contact
//
//  Created by Ilya Tihonkov on 8/3/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import GoogleMaps

typealias ClusterizationComletionHandler = [Cluster] -> Void

class MapModel {

    var clusterizationCompletionHandler: ClusterizationComletionHandler!
    var projection: GMSProjection! {
        didSet {
            clusterizeTickets()
        }
    }
    var categoryWrapper = TicketCategoryWrapper()
    var stateFilters: MapStateFilters! {
        didSet {
            updateFilters()
        }
    }
    var geoTicket: GeoTicket?
    var ticket: Ticket?
    private var geoTickets: [GeoTicket]? {
        didSet {
            if projection != nil {
                clusterizeTickets()
            }
        }
    }
    private(set) var clusters: [Cluster]! {
        didSet {
            clusterizationCompletionHandler(clusters)
        }
    }
    private var fetchPredicates: FetchFilters! {
        didSet {
            clusterizeTickets()
        }
    }
    private weak var locator: ServiceLocator!

    init(serviceLocator: ServiceLocator, ticket: Ticket?) {
        self.locator = serviceLocator
        guard let
            ticket = ticket,
            latitude = ticket.geoAddress?.latitude,
            longitude = ticket.geoAddress?.longitude,
            identifier = ticket.identifier,
            categoryIdentifier = ticket.category?.identifier,
            stateIdentifier = ticket.state?.identifier
            else {
                return
        }
        self.ticket = ticket
        self.geoTicket = GeoTicket(latitude: latitude.doubleValue,
                                   longitude: longitude.doubleValue,
                                   identifier: identifier.integerValue,
                                   stateIdentifier: stateIdentifier.integerValue,
                                   categoryIdentifier: categoryIdentifier.integerValue)

    }

    // MARK: - Public methods

    func requestGeoTickets() {
        let apiClient: RestAPIClient = locator.getService()
        let request = GeoTicketsRequest()
        AlertManager.sharedInstance.showActivity()

        apiClient.executeRequest(request, success: { [weak self] ticketResponse in
            self?.updateFilters()
            self?.geoTickets = GeoTicketsSorter.sort(ticketResponse.geoTickets)
            AlertManager.sharedInstance.hideActivity()
        }) { error in
            AlertManager.sharedInstance.hideActivity()
            AlertManager.sharedInstance.showSimpleAlert(error.message)
        }
    }

    func updateFilters() {
        var categories = [Int]()

        if !categoryWrapper.categories.isEmpty {

            for category in categoryWrapper.categories where category.identifier != nil {
                categories.append(category.identifier!.integerValue)
            }

        }

        if fetchPredicates == nil {
            fetchPredicates = FetchFilters(states: MapStateFilters.All.intValue, categories: categories)
        } else {
            fetchPredicates = FetchFilters(states: self.stateFilters.intValue, categories: categories)
        }
    }

    // MARK: - Private methods

    private func clusterizeTickets() {
        guard let geoTickets = geoTickets else {
            return
        }
        let filteredTickets = filter(geoTickets.filter { element -> Bool in
                projection.visibleRegion().isIncludePoint(element.geoPoint)
            })
        let radius = clusterRadius(from: projection)
        clusters = ClusterizationHelper.clusterize(filteredTickets, clusterRadius: radius)
    }

    private func filter(content: [GeoTicket]) -> [GeoTicket] {
        guard let fetchPredicates = fetchPredicates else {
            return content
        }
        let filteredContent = content.filter { geoTicket -> Bool in
            if fetchPredicates.states.contains(geoTicket.stateIdentifier) {
                if fetchPredicates.categories.isEmpty {
                    return true
                } else {
                    return fetchPredicates.categories.contains(geoTicket.categoryIdentifier)
                }
            }
            return false
        }

        return filteredContent
    }


    private func clusterRadius(from projection: GMSProjection) -> Double {
        let radiusCoordinate = projection.coordinateForPoint(CGPoint(x: 0, y: Constants.GoogleMaps.ClusterRadius))

        return projection.coordinateForPoint(CGPoint.zero).distanceToPoint(radiusCoordinate)
    }

}
