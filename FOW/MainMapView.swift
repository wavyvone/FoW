//
//  MainMapView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/13/23.
//

import SwiftUI
import MapKit
import Firebase

struct MainMapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // get the location of the user
    @StateObject var locationManager = LocationManager()
    
    // AuthManager check if user is logged in or not.
    @EnvironmentObject var authManager: AuthManager
    
    // Color : 89DAFF
    let azurBlue = UIColor(rgb: 0x89DAFF)
    
    var region: Binding<MKCoordinateRegion>? {
        guard let location = locationManager.location else {
            return MKCoordinateRegion.goldenGateRegion().getBinding()
        }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10, longitudinalMeters: 10)

        print(location.coordinate)
        
        return region.getBinding()
    }
    
    // at this point the location should be updated lmao and given
    
    var body: some View {
        if let currLocation = region {
            ZStack{
                // Need to add Map Here

                Color(azurBlue).ignoresSafeArea()
                
                Map(coordinateRegion: currLocation, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow))
                    .ignoresSafeArea()
                /*MapViewControllerBridge(latitude: currLocation.coordinate.latitude, longitude: currLocation.coordinate.longitude).edgesIgnoringSafeArea(.top)
                    .edgesIgnoringSafeArea(.bottom)*/
                
                let latitude = currLocation.center.latitude.wrappedValue
                let longitude = currLocation.center.longitude.wrappedValue
                    
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack{
                            Text("Welcome to your map!").foregroundColor(.black)
                            //Text(String(describing: latitude))
                            Text("\(latitude) \(longitude)")
                        } // VStack
                        .toolbar {
                            Button("Logout") {
                                // Close the popup and switch to LoginView
                                logout()
                            }
                            .font(Font.custom("OpenSans-Regular", size: 18))
                        }
                        Spacer()
                    } // HStack
                    Spacer()
                } // VStack
            } // ZStack
        } // if
    } // Body
    
    func logout(){
        print("Tapped logout")
        // firebase change the logout to logout state
        authManager.logout()
        presentationMode.wrappedValue.dismiss()
    }
    
} // Main

struct MainMapView_Previews: PreviewProvider {
    static var previews: some View {
        MainMapView()
    }
}
