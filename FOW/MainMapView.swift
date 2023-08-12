//
//  MainMapView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/13/23.
//

import SwiftUI
import Firebase

struct MainMapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // get the location of the user
    @ObservedObject var locationManager = LocationManager.shared
    
    // AuthManager check if user is logged in or not.
    @EnvironmentObject var authManager: AuthManager
    
    // Color : 89DAFF
    let azurBlue = UIColor(rgb: 0x89DAFF)
    
    // at this point the location should be updated lmao and given
    
    var body: some View {
        if let currLocation = locationManager.userLocation {
            ZStack{
                // Need to add Map Here
                
                
                
                Color(azurBlue).ignoresSafeArea()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack{
                            Text("Welcome to your map!")
                            Text("\(currLocation)")
                                .padding()
                            
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
