//
//  ContentToLoginView.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import SwiftUI

struct ContentToLoginView: View {
    
    // Double check if the user has location shared or not.
    //@ObservedObject var locationManager = LocationManager.shared
    let locationAuth = LocationAuth()
    
    // AuthManager check if user is logged in or not.
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        if authManager.isLoggedIn{
            // If user is already logged in, check location permission.

            if locationAuth == nil {
                LocationQueryView()
            } else {
                // Logged in and location is given.
                ViewToMainMapView()
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(authManager)
                // Make sure the user can't accidently back out unless using the
                // logout button.
            }
        } else {
            // Go to login view.
            LoginView().environmentObject(authManager)
        }
    } // body
    
    
}

struct ContentToLoginView_Previews: PreviewProvider {
    static var previews: some View {
        ContentToLoginView()
    }
}
