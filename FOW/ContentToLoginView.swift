//
//  ContentToLoginView.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import SwiftUI

struct ContentToLoginView: View {
    
    // Double check if the user has location shared or not
    @ObservedObject var locationManager = LocationManager.shared
    
    // AuthManager check if user is logged in or not.
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isLoggedIn && locationManager.userLocation == nil {
            LocationQueryView()
            
        // check if user logged in successfully and shared location
        } else if authManager.isLoggedIn && locationManager.userLocation != nil {
            ViewToMainMapView()
                .navigationBarBackButtonHidden(true)
                .environmentObject(authManager)
            // make sure the user can't accidently back out unless using the
            // logout button
            
        } else {
            // go to login view
            LoginView()
        }
    } // body
    
    
}

struct ContentToLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentToLoginView()
    }
}
