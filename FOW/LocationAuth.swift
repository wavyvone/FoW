//
//  LocationAuth.swift
//  FOW
//
//  Created by Yvonne Chen on 8/18/23.
//

import CoreLocation

class LocationAuth: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationAuth: CLLocationManager?
    
    @Published var isLocationAuthorized: Bool = false
    
    override init() {
        super.init()
        locationAuth = CLLocationManager()
        locationAuth?.delegate = self
        checkLocationAuthorization()
    }
    
    func checkIfLocationServicesEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationAuth = CLLocationManager()
            locationAuth!.delegate = self
            checkLocationAuthorization()
        } else {
            print("Show alert to let user know that location is off and they need to turn it on.")
            isLocationAuthorized = false
        }
    }
    
    func checkLocationAuthorization() {
        guard let locationAuth = locationAuth else { return }
        
        switch locationAuth.authorizationStatus {
            case .notDetermined:
                locationAuth.requestWhenInUseAuthorization()
            case .restricted:
                print("DEBUG: restricted")
                isLocationAuthorized = false
            case .denied:
                print("DEBUG: denied")
                isLocationAuthorized = false
            case .authorizedAlways:
                print("DEBUG: authorizedAlways")
                isLocationAuthorized = true
            case .authorizedWhenInUse:
                print("DEBUG: authorizedWhenInUse")
                isLocationAuthorized = true
            case .authorized:
                print("DEBUG: authorized")
                isLocationAuthorized = true
            @unknown default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
