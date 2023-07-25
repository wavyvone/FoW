//
//  LocationManager.swift
//  FOW
//
//  Created by Yvonne Chen on 7/25/23.
//

// Courtesy of this youtuber https://www.youtube.com/watch?v=poSmKJ_spts
import CoreLocation

class LocationManager: NSObject, ObservableObject{
    // this "manager" is what we will use to
    private let manager = CLLocationManager()
    // We dont have the user location yet when we initialize so we have to
    // grab from manager
    // Published bc if user location is not allowed we will request and prompt
    // Want to display map after they accept
    @Published var userLocation: CLLocation?
    // shared allows us to access this manager anywhere in the app
    static let shared = LocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        // Standard locattion
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    // obvious
    func requestLoaction(){
        // only access user location when app is in use.
        // access location when app is not in use can be taxing on battery
        manager.requestWhenInUseAuthorization()
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    // User giving us their permission or not?
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: notDetermined")
        case .restricted:
            print("DEBUG: restricted")
        case .denied:
            print("DEBUG: denied")
        case .authorizedAlways:
            print("DEBUG: authorizedAlways")
        case .authorizedWhenInUse:
            print("DEBUG: authorizedWhenInUse")
        case .authorized:
            print("DEBUG: authorized")
        @unknown default:
            break
        }
    }
    
    // When we do get user's location and it updates!
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
}