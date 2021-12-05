//
//  PinInformation.swift
//  MapLocation
//
//  Created by Guohao Tong on 12/4/21.
//

import Foundation
import MapKit
//import SwiftyJSON

class PinInformation: NSObject, MKAnnotation{
    let title:String?
    let LocationName: String
    let coordinate: CLLocationCoordinate2D
    
    init(title:String, LocationName:String, discipline:String, coordinate:CLLocationCoordinate2D) {
        self.title=title
        self.LocationName=LocationName
        self.coordinate=coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return LocationName
    }
    
//    class func from(json: JSON) -> Venue?
//    {
//        var title: String
//        if let unwrappedTitle = json["name"].string {
//            title = unwrappedTitle
//        } else {
//            title = ""
//        }
//        
//        let locationName = json["location"]["address"].string
//        let lat = json["location"]["lat"].doubleValue
//        let long = json["location"]["lng"].doubleValue
//        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        
//        return Venue(title: title, locationName: locationName, coordinate: coordinate)
//    }
    
//    func mapItem() -> MKMapItem
//    {
//        let addressDictionary = [String(kABPersonAddressStreetKey) : subtitle]
//        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
//        let mapItem = MKMapItem(placemark: placemark)
//
//        mapItem.name = "\(title) \(subtitle)"
//
//        return mapItem
//    }
}
