//
//  PlacesHelper.swift
//  e-contact
//
//  Created by Illya on 4/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import Foundation
import GoogleMaps

final class PlacesHelper {

    static func pickPlace(completion: (TicketGeoAddress) -> () ) {
        let locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePicker(config: config)

        placePicker.pickPlaceWithCallback { (place: GMSPlace?, error: NSError?) -> Void in
            if let error = error {
                AlertManager.sharedInstance.showSimpleAlert("Pick Place error: \(error.localizedDescription)")
                return
            }

            if let place = place {
                guard let geoAddress = TicketGeoAddress.createEntityWithPlace(place) else { return }
                completion(geoAddress)
            }
        }
    }

}
