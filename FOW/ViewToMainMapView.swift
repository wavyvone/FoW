//
//  ViewToMainMapView.swift
//  FOW
//
//  Created by Yvonne Chen on 8/10/23.
//

import SwiftUI
import Firebase

struct ViewToMainMapView: View {
    // get the location of the user
    @ObservedObject var locationAuth = LocationAuth.shared
    
    // AuthManager check if user is logged in or not.
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        // Check if user give location permissions.
        if locationAuth.isLocationAuthorized {
            MainMapView().environmentObject(authManager)
        } else {
            LocationQueryView().environmentObject(authManager)
        }
    }

}

struct ViewToMainMapView_Previews: PreviewProvider {
    static var previews: some View {
        ViewToMainMapView()
    }
}
