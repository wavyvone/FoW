//
//  ContentToSignupView.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import SwiftUI
import Firebase

struct ContentToSignupView: View {
    
    // Double check if the user has location shared or not
    @ObservedObject var locationManager = LocationManager.shared
    
    // Insert Authmanager environment object
    @EnvironmentObject var authManager: AuthManager
    
    
    var body: some View {
        // if user successfully signs in and userlocation is not given
        // user didnt give us their location
        if authManager.isLoggedIn {
            if locationManager.userLocation == nil {
                LocationQueryView()
            } else {
                // go to map once signup all works
                ViewToMainMapView()
                    .navigationBarBackButtonHidden(true)
                    .environmentObject(authManager)
            }
        } else {
            // Go to Sign up
            SignupView().environmentObject(authManager)
        }
    }
}

struct ContentToSignupView_Previews: PreviewProvider {
    static var previews: some View {
        ContentToSignupView()
    }
}
