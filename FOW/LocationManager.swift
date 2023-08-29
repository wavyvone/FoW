//
//  LocationManager.swift
//  FOW
//
//  Created by Yvonne Chen on 7/25/23.
//

// Courtesy of this youtuber https://www.youtube.com/watch?v=poSmKJ_spts
import Foundation
import MapKit
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject{
    // this "manager" is what we will use to
    private let locationManager = CLLocationManager()
    // We dont have the user location yet when we initialize so we have to
    // grab from manager
    // Published bc if user location is not allowed we will request and prompt
    // Want to display map after they accept
    @Published var location: CLLocation?
    
    private var hasSetRegion = false

    /**
     Location will start updating once the app starts. First checks if user did give permission
     */
    override init() {
        super.init()
        // Standard locattion
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        //locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("stop test")
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // receive location as it updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Location Update none: ")
            print(locations)
            return
        }
        DispatchQueue.main.async {
            self.location = location
        }
    }
    /**
     When we do get user's location and it updates!
     */
    /*func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }*/
}

extension MKCoordinateRegion {
    
    static func goldenGateRegion() -> MKCoordinateRegion {
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.819527098978355, longitude:  -122.47854602016669), latitudinalMeters: 5, longitudinalMeters: 5)
    }
    
    func getBinding() -> Binding<MKCoordinateRegion>? {
        return Binding<MKCoordinateRegion>(.constant(self))
    }
}
