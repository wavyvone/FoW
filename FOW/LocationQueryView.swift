//
//  LocationQueryView.swift
//  FOW
//
//  Created by Yvonne Chen on 7/25/23.
//

import SwiftUI

struct LocationQueryView: View {
    // Location Services!
    
    // Colors
    let peach = UIColor(rgb: 0xF9B5AC)
    let lavender = UIColor(rgb: 0xA7ABDD)
    
    // Padding numbers
    let topPad: Int = 150
    
    var body: some View {
        ZStack{
            Color(peach).ignoresSafeArea()
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    
                    VStack{
                        VStack{
                            // Intro Title
                            Text("First things first, 👀\nWe need your location")
                                .font(.largeTitle)
                                .bold()
                                .padding(.top, 150)
                            Text("Or else how are you going to clear the clouds\non the map?")
                                .padding(.bottom, 20)
                        } // inner VStack
                        
                        // Want the user to press the button and update their acc on firebase to make the location service on.
                        Button(action:agreeLocation){
                            Text("Allow location")
                                .font(.headline)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 20)
                                .frame(width: UIScreen.main.bounds.width-80)
                                .foregroundColor(.black)
                        }.buttonStyle(.borderedProminent)
                            .cornerRadius(16)
                            .accentColor(Color(lavender))
                            .padding(.top, 40)
                            .padding(.bottom, 20)
                        
                        //Button change to the capsules
                        
                        NavigationLink(destination: ContentView()) {
                            Text("Maybe later")
                                .font(.headline)
                        }
                        // Honestly Users can just back out and delete the app.
                        
                        Spacer()
                        
                    } // outer VStack
                    
                    Spacer()
                } // HStack
                Spacer()
            } // Outer VStack
        } // Outer ZStack
        
        // https://stackoverflow.com/questions/64558834/how-to-call-swiftui-navigationlink-conditionally
        NavigationLink(destination: MainMapView()){
            
        }
            
    } // body
    func agreeLocation() {
        
    }
}

struct LocationQueryView_Previews: PreviewProvider {
    static var previews: some View {
        LocationQueryView()
    }
}
