//
//  MapPhotoViewController.swift
//  AR-Demo
//
//  Created by Guohao Tong on 11/14/21.
//


import UIKit
import MapKit
import CoreLocation

class MapPhotoViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet weak var MapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(MapView)
        MapView.frame = view.bounds
        // Do any additional setup after loading the view.
        MapView.delegate=self
        createPin(locations: annotationInformation)
        zoomMapOn(location: initialLocation)
        //fetchData()
    }
    
    let initialLocation = CLLocation(latitude: 38.648584, longitude: -90.30772)
    
    let annotationInformation = [["title": "Olin Library" , "latitude":38.648584,"longitude":-90.30772],
                                 ["title":"Lopata Hall" , "latitude":38.649108,"longitude":-90.306191],
                                 ["title":"Simon Hall", "latitude":38.648115 , "longitude":-90.311318]
    ]
    
//    var venues = [Venue]()
//
//    func fetchData()
//    {
//        let fileName = Bundle.main.path(forResource: "Venues", ofType: "json")
//        let filePath = URL(fileURLWithPath: fileName!)
//        var data: Data?
//        do {
//            data = try Data(contentsOf: filePath, options: Data.ReadingOptions(rawValue: 0))
//        } catch let error {
//            data = nil
//            print("Report error \(error.localizedDescription)")
//        }
//
//        if let jsonData = data {
//            let json = JSON(data: jsonData)
//            if let venueJSONs = json["response"]["venues"].array {
//                for venueJSON in venueJSONs {
//                    if let venue = Venue.from(json: venueJSON) {
//                        self.venues.append(venue)
//                    }
//                }
//            }
//        }
//    }
    
    func createPin(locations:[[String : Any]]){
        for location in locations{
            let pin = MKPointAnnotation()
            pin.title = location["title"] as! String
            pin.coordinate=CLLocationCoordinate2D(latitude: location["latitude"] as! CLLocationDegrees, longitude:location["longitude"] as! CLLocationDegrees)
            //MapView.setRegion(MKCoordinateRegion(center: pin.coordinate, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50)), animated: false)
            MapView.addAnnotation(pin)
            
//            let i: UIImage
//            MapView.largeContentImage = i
            
        }
        
    }
    private let regionRadius: CLLocationDistance = 1000
    func zoomMapOn(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        MapView.setRegion(coordinateRegion, animated: true)
    }
}

extension MapPhotoViewController{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        var annotationView = MapView.dequeueReusableAnnotationView(withIdentifier: "image")

        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "image")
            annotationView?.canShowCallout = false

        }

        else{
            annotationView?.annotation=annotation
        }
        
        //for image in images{
            annotationView?.image=UIImage(named: "dog")
        //}
        
        
        
        
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        
        //annotationView?.calloutOffset = CGPoint(x: -10000,y: 100000)
        annotationView?.centerOffset=CGPoint(x: -1,y: 1)
        annotationView?.sizeToFit()
        
        return annotationView
    }
}

