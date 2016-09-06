//
//  MapViewController.swift
//  e-contact
//
//  Created by Illya on 1/8/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

struct FetchFilters {

    var states: [Int]
    var categories: [Int]

}

final class MapViewController: UIViewController, StoryboardInitable {

    struct SegmentedControlContentView {

        static let LeadingIndent: CGFloat = -1
        static let TopIndent: CGFloat = 0
        static let TrailingIndent: CGFloat = 2
        static let Height: CGFloat = 49

        static var frame: CGRect = {
            return CGRect(
                x: SegmentedControlContentView.LeadingIndent,
                y: SegmentedControlContentView.TopIndent,
                width: SegmentedControlContentView.TrailingIndent,
                height: SegmentedControlContentView.Height
            )
        }()
    }

    struct SegmentedControlView {

        static let LeadingIndent: CGFloat = 8
        static let TopIndent: CGFloat = 9
        static let TrailingIndent: CGFloat = 15
        static let Height: CGFloat = 33

        static var frame: CGRect = {
            return CGRect(
                x: SegmentedControlView.LeadingIndent,
                y: SegmentedControlView.TopIndent,
                width: SegmentedControlView.TrailingIndent,
                height: SegmentedControlView.Height
            )
        }()
    }

    static let storyboardName = "Map"

    var model: MapModel!

    private var segmentedControl = MapSegmentedControl()

    private var router: MapRouter!
    private var mapView: GMSMapView!

    @IBOutlet private var filterButton: UIBarButtonItem!

    // MARK: Lifecycle

    override func loadView() {
        self.view = viewForController()

        subscribeForAlerts()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let ticket =  model.ticket {
            setupView(with: ticket)
        } else {
            setupViewForMapWithClusters()
        }

        setupBackBarButtonItem()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        subscribeForAlerts() // we have to use it two times
        if model.ticket == nil {
            updateFilterItemImage()
            model.updateFilters()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        UserInteractionLocker.unlock()
        if model.ticket == nil {
            model.projection = mapView.projection
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if  model.ticket == nil {
            setupSegmentedControl()
        }
    }

    // MARK: Mutators

    func setRouter(router: MapRouter) {
        self.router = router
    }

    // MARK: Private methos

    private func setupBackBarButtonItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.BackItem(self, action: #selector(navigateBackwards))
    }

    private func setupViewForMapWithClusters() {
        mapView.delegate = self
        segmentedControl.delegate = self
        setupModel()
        model.requestGeoTickets()
    }

    private func updateFilterItemImage() {
        let image = !model.categoryWrapper.isEmpty ? AppImages.filterActive : AppImages.filterDisabled
        let filterItem = UIBarButtonItem(image: image,
                                         style: .Plain,
                                         target: self,
                                         action: #selector(MapViewController.categoryFiltersButtonTapped))
        navigationItem.rightBarButtonItem = filterItem
    }

    private func setupSegmentedControl() {
        var contentViewFrame = SegmentedControlContentView.frame
        var segmentedControlFrame = SegmentedControlView.frame
        contentViewFrame.size.width = contentViewFrame.width + view.bounds.width
        segmentedControlFrame.size.width = view.bounds.width - segmentedControlFrame.width

        let contentView = UIView(frame: contentViewFrame)
        segmentedControl.frame = segmentedControlFrame
        contentView.backgroundColor = UIColor.whiteColor()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.applicationThemeColor().CGColor

        contentView.addSubview(segmentedControl)
        view.addSubview(contentView)
    }

    private func viewForController() -> GMSMapView {
        if let geoTicket = model.geoTicket {
            return createMapView(with: geoTicket)!
        } else {
            return createMapView()
        }
    }

    private func createMapView(with ticket: GeoTicket) -> GMSMapView? {
        let camera = GMSCameraPosition.cameraWithLatitude(ticket.geoPoint.latitude,
                                                          longitude:ticket.geoPoint.longitude,
                                                          zoom: Float(Constants.GoogleMaps.DefaultZoomLevel))
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        setDefaultsMapViewSettings()

        return mapView
    }

    private func setupView(with ticket: Ticket) {
        filterButton.customView = UIView()

        guard let geoTicket = model.geoTicket else {
            return
        }
        let marker = GMSMarker(ticket: geoTicket)
        marker.tappable = true
        marker.tracksViewChanges = false
        marker.map = mapView

        if let ticketId = ticket.ticketId {
            title = String(format: "ticketCreation.ticket".localized(), ticketId)
            marker.title = ticket.ticketId
        } else {
            self.title = ticket.title
            marker.title = ticket.title
        }
    }

    private func  createMapView() -> GMSMapView {
        let camera = GMSCameraPosition.cameraWithLatitude(Constants.DnepropetrovskCoordinates.Latitude,
                                                          longitude: Constants.DnepropetrovskCoordinates.Longitude,
                                                          zoom: Float(Constants.GoogleMaps.DefaultZoomLevel))
        mapView = GMSMapView.mapWithFrame(CGRect.zero, camera: camera)
        mapView.setMinZoom(Constants.GoogleMaps.MinZoom, maxZoom: Constants.GoogleMaps.MaxZoom)
        mapView.accessibilityElementsHidden = false
        setDefaultsMapViewSettings()

        return mapView
    }

    private func setDefaultsMapViewSettings() {
        mapView.indoorEnabled = false
        mapView.myLocationEnabled = false
        mapView.settings.rotateGestures = false
    }

    private func subscribeForAlerts() {
        AlertManager.sharedInstance.listener = router
    }

    private func setupModel() {
        model.clusterizationCompletionHandler = { [weak self] clusters in
            guard let strongSelf = self else {
                return
            }

            strongSelf.mapView.clear()
            for (clusterIndex, clusterContent) in clusters.enumerate() {
                let marker: GMSMarker
                clusterContent.elements.count == 1 ?
                    (marker = GMSMarker(ticket: clusterContent.elements.first!)) :
                    (marker = GMSMarker(content: clusterContent.elements))
                marker.userData = clusterIndex
                marker.tracksViewChanges = false
                marker.map = strongSelf.mapView
            }

        }
    }

    private func showDetailedTicket(with identifier: NSNumber) {
        router.showDetailedTicket(orWith: identifier.integerValue, from: .Map)
    }

    private func showListOfTickets(with clusterContent: [GeoTicket]) {
        let ticketsIdentifiers: [Int] = clusterContent.map({ $0.identifier })
        router.showClusterContentWithTicketIdentifiers(ticketsIdentifiers)
    }

    // MARK: Actions

    @objc @IBAction private func categoryFiltersButtonTapped(sender: AnyObject?) {
        if UserInteractionLocker.isInterfaceAccessible {
            UserInteractionLocker.lock()
            router.showCategoryPicker(with: model.categoryWrapper, state: .Feed)
        }
    }

    @objc private func navigateBackwards(sender: AnyObject) {
        router.popViewControllerAnimated()
    }

}

extension MapViewController: MapSegmentedControlDelegate {

    func segmentSelected(control: MapSegmentedControl, segment: String) {
        if let filters = MapStateFilters(localizedValue: segment) {
            model.stateFilters = filters
        }
    }

}

extension MapViewController: GMSMapViewDelegate {

    func mapView(mapView: GMSMapView, idleAtCameraPosition position: GMSCameraPosition) {
        model.projection = mapView.projection
    }

    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        guard let identifier = marker.userData as? Int else {
            return false
        }
        let cluster = model.clusters[identifier]

        if cluster.elements.count > 1 {
            showListOfTickets(with: cluster.elements)
        } else if let identifier = cluster.elements.first?.identifier {
            showDetailedTicket(with: identifier)
        }

        return true
    }

}
