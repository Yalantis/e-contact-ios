//
//  Constants.swift
//  e-contact
//
//  Created by Illya on 4/4/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import FastEasyMapping
import Haneke
import DeviceKit

struct Constants {

    static let megabyte = 1024.0 * 1024.0

    struct TicketCreation {

        static let AddPhoto = "ticketCreation.alerts.add_photo".localized()
        static let ChooseFromGallery = "ticketCreation.alerts.choose_from_gallery".localized()
        static let Error = "ticketCreation.alerts.error".localized()
        static let CameraError = "ticketCreation.alerts.camera_not_available".localized()
        static let DeletionTittle = "ticketCreation.alerts.deletion".localized()
        static let DeletionMessage = "ticketCreation.alerts.deletion_message".localized()
        static let SaveToDraftMessage = "ticketCreation.alerts.save_to_draft_message".localized()
        static let UploadingPhotoMessage = "ticketCreation.alerts.uploading_photo".localized()
        static let HidingSize: CGFloat = 0.0
        static let SeparatorHeight: CGFloat = 10.0
        static let ImageCacheDiskCapacity: UInt64  = 1000 * UInt64(megabyte)
        static let ImageBytesSize = Int(1.5 * megabyte)
        static let TopQuality: CGFloat = 1.0
        static let QualityReducer: CGFloat = 0.9
        static let EstimatedRowHeight: CGFloat = 44.0
        static let BarHeight: CGFloat = 44.0
        static let TicketDescriptionMaxCharactersCount = 2000
        static let AddressCellsAnimationDuration: NSTimeInterval = 0.3
        static let TextViewResizingAnimationDuration: NSTimeInterval = 0.2
        static let ImagesGalleryAnimatonDuration: NSTimeInterval = 0.4
        static let ImagePickerDevicesToLimit: [Device] = [.iPhone4, .iPhone4s]
        static let ImagePickerImageLimit = 4
    }

    struct Authorization {

        static let EmptyFields = "registration.error.empty_fields".localized()
        static let WrongEmail = "password.recovery.wrong_email".localized()
    }

    struct DetailedTicket {

        static let StateLAbelWidthInsets: CGFloat = 20.0
    }

    struct ImageUploader {

        static let MemoryThreshold = UInt64(megabyte)
    }

    struct CategoryPicker {

        static let HiddenCounterHeaderHeight: CGFloat = 44.0
        static let EstimatedRowHeight: CGFloat = 50.0
        static let ZeroToTwentyRange = 0...20
    }

    struct ImageCache {

        static let PathSeparator = "/"
        static let NetworkURLPrefix = "http://"
    }

    struct TicketConstants {

        static let IdIncrementer = 1
        static let TypeIdentifier = 5
        static let StateIdentifier = 1
    }

    struct GoogleMaps {

        static let DefaultZoomLevel: CGFloat = 12.0
        static let MinZoom: Float = 6.0
        static let MaxZoom: Float = 20.0
        static let ClusterRadius: CGFloat = 60.0
    }

    struct VisibleRegion {

        static let WidthDivider = 2.0
        static let HeightDivider = 4.0
    }

    struct DnepropetrovskCoordinates {

        static let Latitude = 48.44
        static let Longitude =  35.09
    }

    struct PieChart {

        static let ClusterSize: CGFloat = 50.0
        static let ArcOpacity: Float = 0.7
        static let TextleLayerHeight: CGFloat = 15.0
        static let ArcRadiusReducer: CGFloat = 0.38
        static let Separator: CGFloat = 0.03
    }

    struct Mapping {

        static let NumberToDateMapper: FEMMapBlock = { value -> AnyObject? in
            if let value = value as? NSNumber where value != 0 {
                return NSDate(timeIntervalSince1970: value.doubleValue)
            }
            return nil
        }
    }

    struct TicketsFetching {

        static let TicketsAmount = 10
        static let LoadMoreItemsCooldownInterval = 300.0
        static let ContentOffsetTillLoadingMoreTickets: CGFloat = 2/3
    }

    struct Regexp {

        static let NotWordPattern = "\\W"
        static let EmailRegExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        static let NewLineSybmol = "\n"
        static let NewLineTrimmer = "^\\n*|\\s*$"
        static let FourNewLineSybmols = "\n\n\n\n"
        static let ThreeNewLineSybmols = "\n\n\n"
    }

    struct ImagesGallery {

        static let HeightReducer: CGFloat = 0.65
    }

    struct Notification {

        static let Message = "notification.alert.status_did_changed".localized()
        static let Title = "notification.alert.notification".localized()
    }

    struct Networking {

        static let UsedValueError = "This value is already used."
        static let PhoneError = String(format: "network.error.already_used_value".localized(),
                                       ValidationAttributesKey.Phone.localized())
        static let Сomma = ","
        static let BaseURL: String = {
            let dictionary = NSDictionary.configurationPropertylist()
            // swiftlint:disable force_cast
            let apiURLString = dictionary!["API_URL"] as! String
            let apiVersionString = dictionary!["API_VERSION"] as! String
            // swiftlint:enable force_cast

            return apiURLString + apiVersionString
        }()
    }

    struct Time {

        static let ShowPushNotificationAtAppLaunchDelay: NSTimeInterval = 1.5
        static let TicketCreationAlertDelay: NSTimeInterval = 1.0
        static let DelayForShowingBackButton: NSTimeInterval = 1.0
        static let ChangePasswordAlertDelay: NSTimeInterval = 1.0
        static let TabBarAppearDisappearAnimationDuration: NSTimeInterval = 0.3
        static let ShowPushNotificationDelay: NSTimeInterval = 10.0
    }

    static let ConfigurationPlistKey = "ConfigurationPlist"
    static let RussianAndUkrainianCharactersSet = NSCharacterSet(
        charactersInString: "/'абвгдеёжзийклмнопрстуфхцчшщъыьэюяїієАБВГДЕЖЗІКЛМНОПРСТУФХЧШЩЬЄЮЯЇЭИЫЭЙЦ"
    )
    static let HoursMinutesDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()

        dateFormatter.locale = NSLocale(localeIdentifier: "uk_UA")
        dateFormatter.dateFormat = ", hh:mm"

        return dateFormatter
    }()
    static let MonthDateDateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()

        dateFormatter.locale = NSLocale(localeIdentifier: "uk_UA")
        dateFormatter.dateFormat = "MMMM dd"

        return dateFormatter
    }()
    static let Scale = UIScreen.mainScreen().scale
    static let CategoryIconsFormat = Format<UIImage>(name: "CategoryImages",
                                                     diskCapacity: 10 * UInt64(megabyte),
                                                     transform: nil)
    static let Whitespace = " "
    static let DefaultAnimationDuration: NSTimeInterval = 0.3
    static let IconsVersionKey = "iconsVersion"

}
