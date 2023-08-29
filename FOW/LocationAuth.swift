//
//  LocationAuth.swift
//  FOW
//
//  Created by Yvonne Chen on 8/18/23.
//

import CoreLocation
import UIKit

class LocationAuth: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationAuth: CLLocationManager?
    
    private let manager = CLLocationManager()
    
    // shared allows us to access this manager anywhere in the app
    static let shared = LocationAuth()
    
    @Published var isLocationAuthorized: Bool = false
    @Published var isLocationDenied: Bool = false
    
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
    
    func requestLocation(){
        // only access user location when app is in use.
        // access location when app is not in use can be taxing on battery
        if isLocationDenied {
            if let url = NSURL(string:UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url as URL)
            }
        }
        manager.requestWhenInUseAuthorization()
    }
    
    func checkLocationAuthorization() {
        guard let locationAuth = locationAuth else { return }
        
        switch locationAuth.authorizationStatus {
            case .notDetermined:
                print("DEBUG AUTH: notDetermined")
                isLocationAuthorized = false
                isLocationDenied = false
            case .restricted:
                print("DEBUG AUTH: restricted")
                isLocationAuthorized = false
                isLocationDenied = false
            case .denied:
                print("DEBUG AUTH: denied")
                isLocationAuthorized = false
                isLocationDenied = true
            case .authorizedAlways:
                print("DEBUG AUTH: authorizedAlways")
                isLocationAuthorized = true
                isLocationDenied = false
            case .authorizedWhenInUse:
                print("DEBUG AUTH: authorizedWhenInUse")
                isLocationAuthorized = true
                isLocationDenied = false
            case .authorized:
                print("DEBUG AUTH: authorized")
                isLocationAuthorized = true
                isLocationDenied = false
            @unknown default:
                break
        }
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
}
